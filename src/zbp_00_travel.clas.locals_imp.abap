CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS determine_customer_id FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~determine_customer_id.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD determine_customer_id.

    READ ENTITY IN LOCAL MODE zi_00_booking
     FIELDS ( CustomerId )
     WITH CORRESPONDING #( keys )
     RESULT DATA(bookings)

     BY \_Travel
     FIELDS ( CustomerID )
     WITH CORRESPONDING #( keys )
     RESULT DATA(travels).

    LOOP AT bookings ASSIGNING FIELD-SYMBOL(<booking>).
      MODIFY ENTITIES OF ZI_00_Travel IN LOCAL MODE
        ENTITY booking
        UPDATE FIELDS ( CustomerId )
        WITH VALUE #(
          (
             %tky = <booking>-%tky
             CustomerId = travels[ 1 ]-CustomerId )
          ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS cancel_travel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~cancel_travel.
    METHODS validate_agency_id FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validate_agency_id.
    METHODS determine_travel_id FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~determine_travel_id.
    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR travel RESULT result.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD cancel_travel.

    READ ENTITIES OF ZI_00_Travel IN LOCAL MODE
      ENTITY Travel
      FIELDS ( travelid status )
      WITH CORRESPONDING #( keys )
      RESULT DATA(travels)
      FAILED failed
      REPORTED reported.

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
      IF <travel>-Status = 'C'.
        DATA(message) = NEW zcm_00_travel(
          textid    = zcm_00_travel=>cancel_failed
          severity  = if_abap_behv_message=>severity-information
          travel_id = <travel>-TravelId ).

        APPEND CORRESPONDING #( <travel> ) TO failed-travel.
        APPEND VALUE #(
          traveluuid = <travel>-TravelUuid
          %msg = message
          %element-status = if_abap_behv=>mk-on ) TO reported-travel.
        CONTINUE.
      ENDIF.

      <travel>-status = 'C'.

      MODIFY ENTITIES OF ZI_00_Travel IN LOCAL MODE
        ENTITY Travel
        UPDATE FIELDS ( status )
        WITH VALUE #( ( %tky = <travel>-%tky Status = <travel>-status ) )
        FAILED failed
        REPORTED reported.
    ENDLOOP.

  ENDMETHOD.

  METHOD validate_agency_id.

    DATA message TYPE REF TO zcm_00_travel.

    READ ENTITIES OF zi_00_travel IN LOCAL MODE
     ENTITY Travel
     FIELDS ( AgencyId )
     WITH CORRESPONDING #( keys )
     RESULT DATA(travels).

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).

      IF <travel>-AgencyId IS INITIAL.
        message = NEW zcm_00_travel(
          textid    = zcm_00_travel=>initial_agency_id
          severity  = if_abap_behv_message=>severity-error ).
      ELSE.
        SELECT SINGLE FROM /dmo/agency
          FIELDS agency_id
          WHERE agency_id = @<travel>-AgencyId
          INTO @DATA(agencyid).
        IF sy-subrc <> 0.
          message = NEW zcm_00_travel(
            textid    = zcm_00_travel=>agency_id_not_found
            severity  = if_abap_behv_message=>severity-error
            agency_id = <travel>-AgencyId ).
        ENDIF.
      ENDIF.

      IF message IS BOUND.
        APPEND CORRESPONDING #( <travel> ) TO failed-travel.
        APPEND VALUE #(
          %tky = <travel>-%tky
          %element = VALUE #( agencyid = if_abap_behv=>mk-on )
          %msg = message ) TO reported-travel.
      ENDIF.
      CLEAR message.
    ENDLOOP.

  ENDMETHOD.

  METHOD determine_travel_id.

    READ ENTITIES OF ZI_00_Travel IN LOCAL MODE
     ENTITY Travel
     FIELDS ( TravelId )
     WITH CORRESPONDING #( keys )
     RESULT DATA(travels).

    SELECT SINGLE FROM z00_travel FIELDS MAX( travel_id ) INTO @DATA(max_travel_id).

    MODIFY ENTITIES OF ZI_00_Travel IN LOCAL MODE
     ENTITY Travel
     UPDATE FIELDS ( TravelId )
     WITH VALUE #( FOR <travel> IN travels INDEX INTO idx ( %tky = <travel>-%tky TravelId = max_travel_id + idx ) ).

  ENDMETHOD.

  METHOD get_authorizations.

*    IF requested_authorizations-%update = if_abap_behv=>mk-on
*     OR requested_authorizations-%action-cancel_travel = if_abap_behv=>mk-on.
*
*      READ ENTITIES OF ZI_00_Travel IN LOCAL MODE
*       ENTITY Travel
*       FIELDS ( agencyid )
*       WITH CORRESPONDING #( keys )
*       RESULT DATA(travels).
*
*      LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).
*
*        DATA agencynum TYPE s_agency.
*        agencynum = <travel>-agencyid.
*
*        AUTHORITY-CHECK OBJECT 'S_AGENCY'
*          ID 'AGENCYNUM' FIELD agencynum
*          ID 'ACTVT' FIELD '02'.
*        IF sy-subrc <> 0.
*          APPEND VALUE #(
*            %tky = <travel>-%tky
*            %update = if_abap_behv=>auth-unauthorized
*            %action-cancel_travel = if_abap_behv=>auth-unauthorized ) TO result.
*        ENDIF.
*
*      ENDLOOP.
*
*    ENDIF.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF ZI_00_Travel
     ENTITY Travel
     FIELDS ( CreatedAt CreatedBy LastChangedAt LastChangedBy )
     WITH CORRESPONDING #( keys )
     RESULT DATA(travels).

    LOOP AT travels ASSIGNING FIELD-SYMBOL(<travel>).

      IF <travel>-CreatedBy = <travel>-LastChangedBy.
        APPEND VALUE #(
          %tky = <travel>-%tky
          %features-%field-LastChangedBy = if_abap_behv=>fc-f-read_only ) TO result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
