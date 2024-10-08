SET NOCOUNT ON;

SET IDENTITY_INSERT dbo.Country ON;

INSERT INTO dbo.Country (CountryId, CountryName, CountryCode, CountryCode3) VALUES
 (1,'Canada','CA','CAN')
,(2,'US','US','USA')
,(3,'Mexico','MX','MEX')
,(4,'Peru','PE','PER')
,(5,'Chile','CL','CHL')
,(6,'Brazil','BR','BRA')
,(7,'Afghanistan','AF','AFG')
,(8,'Albania','AL','ALB')
,(9,'Algeria','DZ','DZA')
,(10,'Andorra','AD','AND')
,(11,'Angola','AO','AGO')
,(12,'Antigua and Barbuda','AG','ATG')
,(13,'Argentina','AR','ARG')
,(14,'Armenia','AM','ARM')
,(15,'Australia','AU','AUS')
,(16,'Austria','AT','AUT')
,(17,'Azerbaijan','AZ','AZE')
,(18,'Bahamas, The','BS','BHS')
,(19,'Bahrain','BH','BHR')
,(20,'Bangladesh','BD','BGD')
,(21,'Barbados','BB','BRB')
,(22,'Belarus','BY','BLR')
,(23,'Belgium','BE','BEL')
,(24,'Belize','BZ','BLZ')
,(25,'Benin','BJ','BEN')
,(26,'Bhutan','BT','BTN')
,(27,'Bolivia','BO','BOL')
,(28,'Bosnia and Herzegovina','BA','BIH')
,(29,'Botswana','BW','BWA')
,(30,'Brunei','BN','BRN')
,(31,'Bulgaria','BG','BGR')
,(32,'Burkina Faso','BF','BFA')
,(33,'Burundi','BI','BDI')
,(34,'Cambodia','KH','KHM')
,(35,'Cameroon','CM','CMR')
,(36,'Cape Verde','CV','CPV')
,(37,'Central African Republic','CF','CAF')
,(38,'Chad','TD','TCD')
,(39,'China, People''s Republic of','CN','CHN')
,(40,'Colombia','CO','COL')
,(41,'Comoros','KM','COM')
,(42,'Congo, (The Democratic Republic of the Congo)','CD','COD')
,(43,'Congo, (The Republic of the Congo)','CG','COG')
,(44,'Costa Rica','CR','CRI')
,(45,'Cote d''Ivoire (Ivory Coast)','CI','CIV')
,(46,'Croatia','HR','HRV')
,(47,'Cuba','CU','CUB')
,(48,'Cyprus','CY','CYP')
,(49,'Czech Republic','CZ','CZE')
,(50,'Denmark','DK','DNK')
,(51,'Djibouti','DJ','DJI')
,(52,'Dominica','DM','DMA')
,(53,'Dominican Republic','DO','DOM')
,(54,'Ecuador','EC','ECU')
,(55,'Egypt','EG','EGY')
,(56,'El Salvador','SV','SLV')
,(57,'Equatorial Guinea','GQ','GNQ')
,(58,'Eritrea','ER','ERI')
,(59,'Estonia','EE','EST')
,(60,'Ethiopia','ET','ETH')
,(61,'Fiji','FJ','FJI')
,(62,'Finland','FI','FIN')
,(63,'France','FR','FRA')
,(64,'Gabon','GA','GAB')
,(65,'Gambia, The','GM','GMB')
,(66,'Georgia','GE','GEO')
,(67,'Germany','DE','DEU')
,(68,'Ghana','GH','GHA')
,(69,'Greece','GR','GRC')
,(70,'Grenada','GD','GRD')
,(71,'Guatemala','GT','GTM')
,(72,'Guinea','GN','GIN')
,(73,'Guinea-Bissau','GW','GNB')
,(74,'Guyana','GY','GUY')
,(75,'Haiti','HT','HTI')
,(76,'Honduras','HN','HND')
,(77,'Hungary','HU','HUN')
,(78,'Iceland','IS','ISL')
,(79,'India','IN','IND')
,(80,'Indonesia','ID','IDN')
,(81,'Iran','IR','IRN')
,(82,'Iraq','IQ','IRQ')
,(83,'Ireland','IE','IRL')
,(84,'Israel','IL','ISR')
,(85,'Italy','IT','ITA')
,(86,'Jamaica','JM','JAM')
,(87,'Japan','JP','JPN')
,(88,'Jordan','JO','JOR')
,(89,'Kazakhstan','KZ','KAZ')
,(90,'Kenya','KE','KEN')
,(91,'Kiribati','KI','KIR')
,(92,'Korea, North','KP','PRK')
,(93,'Korea, South','KR','KOR')
,(94,'Kuwait','KW','KWT')
,(95,'Kyrgyzstan','KG','KGZ')
,(96,'Laos','LA','LAO')
,(97,'Latvia','LV','LVA')
,(98,'Lebanon','LB','LBN')
,(99,'Lesotho','LS','LSO')
,(100,'Liberia','LR','LBR')
,(101,'Libya','LY','LBY')
,(102,'Liechtenstein','LI','LIE')
,(103,'Lithuania','LT','LTU')
,(104,'Luxembourg','LU','LUX')
,(105,'Macedonia','MK','MKD')
,(106,'Madagascar','MG','MDG')
,(107,'Malawi','MW','MWI')
,(108,'Malaysia','MY','MYS')
,(109,'Maldives','MV','MDV')
,(110,'Mali','ML','MLI')
,(111,'Malta','MT','MLT')
,(112,'Marshall Islands','MH','MHL')
,(113,'Mauritania','MR','MRT')
,(114,'Mauritius','MU','MUS')
,(115,'Micronesia','FM','FSM')
,(116,'Moldova','MD','MDA')
,(117,'Monaco','MC','MCO')
,(118,'Mongolia','MN','MNG')
,(119,'Montenegro','ME','MNE')
,(120,'Morocco','MA','MAR')
,(121,'Mozambique','MZ','MOZ')
,(122,'Myanmar (Burma)','MM','MMR')
,(123,'Namibia','NA','NAM')
,(124,'Nauru','NR','NRU')
,(125,'Nepal','NP','NPL')
,(126,'Netherlands','NL','NLD')
,(127,'New Zealand','NZ','NZL')
,(128,'Nicaragua','NI','NIC')
,(129,'Niger','NE','NER')
,(130,'Nigeria','NG','NGA')
,(131,'Norway','NO','NOR')
,(132,'Oman','OM','OMN')
,(133,'Pakistan','PK','PAK')
,(134,'Palau','PW','PLW')
,(135,'Panama','PA','PAN')
,(136,'Papua New Guinea','PG','PNG')
,(137,'Paraguay','PY','PRY')
,(138,'Philippines','PH','PHL')
,(139,'Poland','PL','POL')
,(140,'Portugal','PT','PRT')
,(141,'Qatar','QA','QAT')
,(142,'Romania','RO','ROU')
,(143,'Russia','RU','RUS')
,(144,'Rwanda','RW','RWA')
,(145,'Saint Kitts and Nevis','KN','KNA')
,(146,'Saint Lucia','LC','LCA')
,(147,'Saint Vincent and the Grenadines','VC','VCT')
,(148,'Samoa','WS','WSM')
,(149,'San Marino','SM','SMR')
,(150,'Sao Tome and Principe','ST','STP')
,(151,'Saudi Arabia','SA','SAU')
,(152,'Senegal','SN','SEN')
,(153,'Serbia','RS','SRB')
,(154,'Seychelles','SC','SYC')
,(155,'Sierra Leone','SL','SLE')
,(156,'Singapore','SG','SGP')
,(157,'Slovakia','SK','SVK')
,(158,'Slovenia','SI','SVN')
,(159,'Solomon Islands','SB','SLB')
,(160,'Somalia','SO','SOM')
,(161,'South Africa','ZA','ZAF')
,(162,'Spain','ES','ESP')
,(163,'Sri Lanka','LK','LKA')
,(164,'Sudan','SD','SDN')
,(165,'Suriname','SR','SUR')
,(166,'Swaziland','SZ','SWZ')
,(167,'Sweden','SE','SWE')
,(168,'Switzerland','CH','CHE')
,(169,'Syria','SY','SYR')
,(170,'Tajikistan','TJ','TJK')
,(171,'Tanzania','TZ','TZA')
,(172,'Thailand','TH','THA')
,(173,'Timor-Leste (East Timor)','TL','TLS')
,(174,'Togo','TG','TGO')
,(175,'Tonga','TO','TON')
,(176,'Trinidad and Tobago','TT','TTO')
,(177,'Tunisia','TN','TUN')
,(178,'Turkey','TR','TUR')
,(179,'Turkmenistan','TM','TKM')
,(180,'Tuvalu','TV','TUV')
,(181,'Uganda','UG','UGA')
,(182,'Ukraine','UA','UKR')
,(183,'United Arab Emirates','AE','ARE')
,(184,'United Kingdom','GB','GBR')
,(185,'Uruguay','UY','URY')
,(186,'Uzbekistan','UZ','UZB')
,(187,'Vanuatu','VU','VUT')
,(188,'Vatican City','VA','VAT')
,(189,'Venezuela','VE','VEN')
,(190,'Vietnam','VN','VNM')
,(191,'Yemen','YE','YEM')
,(192,'Zambia','ZM','ZMB')
,(193,'Zimbabwe','ZW','ZWE')

SET IDENTITY_INSERT dbo.Country OFF;

GO

