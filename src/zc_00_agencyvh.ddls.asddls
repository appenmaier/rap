@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Agency'
define view entity ZC_00_AgencyVH
  as select from /dmo/agency
{
  key agency_id     as AgencyId,
      name          as Name,
      street        as Street,
      postal_code   as PostalCode,
      city          as City,
      country_code  as CountryCode,
      phone_number  as PhoneNumber,
      email_address as EmailAddress,
      web_address   as WebAddress
}
