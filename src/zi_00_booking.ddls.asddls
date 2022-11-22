@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface-View: Booking'
define view entity ZI_00_Booking
  as select from z00_booking
  association to parent ZI_00_Travel as _Travel on $projection.TravelUuid = _Travel.TravelUuid
{
  key booking_uuid          as BookingUuid,
      travel_uuid           as TravelUuid,
      booking_id            as BookingId,
      booking_date          as BookingDate,
      customer_id           as CustomerId,
      carrier_id            as CarrierId,
      connection_id         as ConnectionId,
      flight_date           as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price          as FlightPrice,
      currency_code         as CurrencyCode,

      /* Administrative Data */
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      /* Associations */
      _Travel
}
