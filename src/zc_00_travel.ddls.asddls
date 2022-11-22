@EndUserText.label: 'Projection View: Travel'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_00_Travel
  as projection on ZI_00_Travel
{
  key TravelUuid,
      TravelId,
      @Consumption.valueHelpDefinition:
        [{ entity: { name: 'ZC_00_AgencyVH', element: 'AgencyId' }}]
      AgencyId,
      CustomerId,
      BeginDate,
      EndDate,
      BookingFee,
      TotalPrice,
      CurrencyCode,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      Description,
      Status,

      /* Administrative Data */
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      /* Assocations */
      _Bookings : redirected to composition child ZC_00_Booking
}
