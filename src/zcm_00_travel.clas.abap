CLASS zcm_00_travel DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    CONSTANTS:
      BEGIN OF cancel_failed,
        msgid TYPE symsgid VALUE 'Z00_TRAVEL',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'TRAVEL_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF cancel_failed.

    CONSTANTS:
      BEGIN OF initial_agency_id,
        msgid TYPE symsgid VALUE 'Z00_TRAVEL',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF initial_agency_id.

    CONSTANTS:
      BEGIN OF agency_id_not_found,
        msgid TYPE symsgid VALUE 'Z00_TRAVEL',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'AGENCY_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF agency_id_not_found.

    DATA travel_id TYPE /dmo/travel_id.
    DATA agency_id TYPE /dmo/agency_id.

    METHODS constructor
      IMPORTING
        textid    LIKE if_t100_message=>t100key OPTIONAL
        previous  LIKE previous OPTIONAL
        severity  TYPE if_abap_behv_message=>t_severity OPTIONAL
        travel_id TYPE /dmo/travel_id OPTIONAL
        agency_id TYPE /dmo/agency_id OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS zcm_00_travel IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.

    me->travel_id = travel_id.
    me->agency_id = agency_id.

    if_abap_behv_message~m_severity = severity.

    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
