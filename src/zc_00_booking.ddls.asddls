@EndUserText.label: 'Projection View: Booking'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_00_Booking
  as projection on ZI_00_Booking
{
  key BookingUuid,
      TravelUuid,
      BookingId,
      BookingDate,
      CustomerId,
      CarrierId,
      ConnectionId,
      FlightDate,
      FlightPrice,
      CurrencyCode,
      CreatedBy,
      LastChangedBy,
      LocalLastChangedAt,

      /* Associations */
      _Travel : redirected to parent ZC_00_Travel
}
