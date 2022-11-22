CLASS zcl_00_travel_genrator DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_00_travel_genrator IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA travel TYPE z00_travel.
    DATA travels TYPE TABLE OF z00_travel.

    DELETE FROM z00_travel.

    SELECT FROM /dmo/travel FIELDS * WHERE createdby NOT LIKE 'CB%' INTO @DATA(tmp).
      travel = CORRESPONDING #( tmp ).
      travel-travel_uuid = cl_system_uuid=>create_uuid_x16_static( ).
      CLEAR travel-travel_id.
      travel-status = tmp-status.
      travel-created_at = tmp-createdat.
      travel-created_by = tmp-createdby.
      travel-last_changed_at = tmp-lastchangedat.
      travel-last_changed_by = tmp-lastchangedby.
      APPEND travel TO travels.
    ENDSELECT.

    INSERT z00_travel FROM TABLE @travels.
    out->write( |sy-dbcnt: { sy-dbcnt }| ).
  ENDMETHOD.

ENDCLASS.

