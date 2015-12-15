-- Estimate buffet bulan 11
SELECT
      --orderline_id,
      localization,
      platform,
      "payment gateway",
      sum(qty) as qty,
      sum("final price idr") "sales idr",
      sum("final price usd") "sales usd",
      sum("final price sgd") "sales sgd",
      sum("publisher share idr") "publisher share idr",
      sum("publisher share usd") "publisher share usd",
      sum("publisher share sgd") "publisher share sgd"
FROM
      finance_report

WHERE 1=1
	    AND "period date" = '2015-11'
  --     AND "vendor id"  = 333

GROUP BY
      localization,
      platform,
      "payment gateway"
ORDER BY
--       orderline_id,
      localization,
      platform;

-- Rekap buffet bulan 11
SELECT
	"vendor currency",
	publisher,
	SUM("Apple iTunes") "Apple iTunes",
	SUM("SCOOP Point iOS") "SCOOP Point iOS",
	SUM("Google In-App Billing") "Android Google In-App Billing",
	SUM("ATM Transfer Android") "ATM Transfer Android",
	SUM("SCOOP Point Android") "SCOOP Point Android",
	SUM("Paypal Android") "Paypal Android",
	SUM("CIMB Clicks Android") "CIMB Clicks Android",
	SUM("Credit Card Android") "Credit Card Android",
	SUM("Mandiri Clickpay Android") "Mandiri Clickpay Android",
	SUM("Mandiri E-Cash Android") "Mandiri E-Cash Android",
	SUM("Elevenia") "Elevenia",
	SUM("Free Purchase Web") "Free Purchase Web",
	SUM("Klikpay BCA Web") "Klikpay BCA Web",
	SUM("ATM Transfer Web") "ATM Transfer Web" ,
	SUM("CIMB Clicks Web") "CIMB Clicks Web",
	SUM("Credit Card Web") "Credit Card Web",
	SUM("Mandiri Clickpay Web") "Mandiri Clickpay Web",
	SUM("Mandiri E-Cash Web") "Mandiri E-Cash Web",
	SUM("Paypal Web") "Paypal Web",
	SUM("SCOOP Point Web") "SCOOP Point Web"

FROM (
      SELECT
            "vendor currency"
            ,publisher
            ,SUM(CASE WHEN "payment gateway"= 'Apple iTunes' THEN "publisher net share by currency" END ) AS "Apple iTunes"
            ,SUM(CASE WHEN "payment gateway"= 'Google In-App Billing' THEN "publisher net share by currency" END ) AS "Google In-App Billing"
            ,SUM(CASE WHEN "payment gateway"= 'ATM Transfer' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "ATM Transfer Web"
            ,SUM(CASE WHEN "payment gateway"= 'ATM Transfer' AND platform = 'Android' THEN "publisher net share by currency" END ) AS "ATM Transfer Android"
            ,SUM(CASE WHEN "payment gateway"= 'CIMB Clicks' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "CIMB Clicks Web"
            ,SUM(CASE WHEN "payment gateway"= 'CIMB Clicks' AND platform = 'Android' THEN "publisher net share by currency" END ) AS "CIMB Clicks Android"
            ,SUM(CASE WHEN "payment gateway"= 'Credit Card' AND platform = 'Android' THEN "publisher net share by currency" END ) AS "Credit Card Android"
            ,SUM(CASE WHEN "payment gateway"='Credit Card' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "Credit Card Web"
            ,SUM(CASE WHEN "payment gateway"='Elevenia' THEN "publisher net share by currency" END ) AS "Elevenia"
            ,SUM(CASE WHEN "payment gateway"='Free Purchase' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "Free Purchase Web"
            ,SUM(CASE WHEN "payment gateway"='Klikpay BCA' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "Klikpay BCA Web"
            ,SUM(CASE WHEN "payment gateway"='Mandiri Clickpay' AND platform = 'Android' THEN "publisher net share by currency" END ) AS "Mandiri Clickpay Android"
            ,SUM(CASE WHEN "payment gateway"='Mandiri Clickpay' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "Mandiri Clickpay Web"
            ,SUM(CASE WHEN "payment gateway"='Mandiri E-Cash' AND platform = 'Android' THEN "publisher net share by currency" END ) AS "Mandiri E-Cash Android"
            ,SUM(CASE WHEN "payment gateway"='Mandiri E-Cash' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "Mandiri E-Cash Web"
            ,SUM(CASE WHEN "payment gateway"='Paypal' AND platform = 'Android' THEN "publisher net share by currency" END ) AS "Paypal Android"
            ,SUM(CASE WHEN "payment gateway"='Paypal' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "Paypal Web"
            ,SUM(CASE WHEN "payment gateway"='SCOOP Point' AND platform = 'Android' THEN "publisher net share by currency" END ) AS "SCOOP Point Android"
            ,SUM(CASE WHEN "payment gateway"='SCOOP Point' AND platform = 'iOS' THEN "publisher net share by currency" END ) AS "SCOOP Point iOS"
            ,SUM(CASE WHEN "payment gateway"='SCOOP Point' AND platform = 'Web' THEN "publisher net share by currency" END ) AS "SCOOP Point Web"

			FROM
				    finance_report

      WHERE 1=1
             AND "period date"  =    '2015-11'

			GROUP BY
            "vendor currency",
            publisher,
            "payment gateway"
			ORDER BY
		    		publisher
    	) AS foo

GROUP BY
	publisher,
	"vendor currency";

--YF Cohort Analysis
WITH buffet AS (
SELECT
  f_sales_new.orderline_id,
  d_users.user_id,
  valid_from_date.date AS valid_from_date,
  valid_until_date.date AS valid_to_date,
  row_number() OVER ( PARTITION BY d_users.user_id ORDER BY orderline_id) AS subscription_number,
  d_clients.client_category
FROM
  f_sales_new
  JOIN d_date valid_from_date ON valid_from_date.date_key = f_sales_new.valid_from_date_key
  JOIN d_date valid_until_date ON valid_until_date.date_key = f_sales_new.valid_to_date_key
  JOIN d_users ON d_users.user_key = f_sales_new.user_key
  JOIN d_offers ON d_offers.offer_key = f_sales_new.offer_key
  JOIN d_clients ON d_clients.client_key = f_sales_new.client_key
WHERE
  d_offers.offer_purchase_plan = 'Buffet'
)

SELECT
  first_subscription_period,
  COUNT(DISTINCT CASE WHEN number_of_subscription = 1 THEN user_id ELSE null END) AS "1st",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 2 THEN user_id ELSE null END) AS "2nd",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 3 THEN user_id ELSE null END) AS "3rd",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 4 THEN user_id ELSE null END) AS "4th",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 5 THEN user_id ELSE null END) AS "5th",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 6 THEN user_id ELSE null END) AS "6th",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 7 THEN user_id ELSE null END) AS "7th",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 8 THEN user_id ELSE null END) AS "8th",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 9 THEN user_id ELSE null END) AS "9th",
  COUNT(DISTINCT CASE WHEN number_of_subscription = 10 THEN user_id ELSE null END) AS "10th"
FROM (
  SELECT
    buffet.user_id,
    TO_CHAR(first_subscription_date, 'YYYY-MM') AS first_subscription_period,
    EXTRACT(month FROM valid_from_date) - EXTRACT(month FROM first_subscription_date) + 1 AS number_of_subscription
  FROM
    buffet
    JOIN (
           SELECT user_id, MIN(valid_from_date) AS first_subscription_date FROM buffet GROUP BY user_id
         ) first ON first.user_id = buffet.user_id
  ) data
GROUP BY
  first_subscription_period;

--Jasper portal
SELECT
	DISTINCT
	--"period date" AS period,
	"vendor currency" AS currency_from,
  --currency_from,
	"vendor currency" AS currency_to,
  --currency_to,
	publisher as name,
	9735.0885 rate
--   rate

FROM
	finance_report
-- LEFT JOIN currency_fixed_rate ON currency_fixed_rate.payment_period = finance_report."period date"

WHERE 1=1
	AND "period date"  =    '2015-10'
	AND "vendor id"  =       333
;

-- TODO: purchase plan
SELECT
  utc_sales_month,
  utc_sales_month_name,
  utc_sales_year,
  CASE
    WHEN offer_purchase_plan = 'Single' THEN 1
    WHEN offer_purchase_plan = 'Subscription' THEN 2
    WHEN offer_purchase_plan = 'Buffet' THEN 3
    WHEN offer_purchase_plan = 'Bundle' THEN 4
    END AS id_offer_purchase_plan,
  offer_purchase_plan,
  COUNT(DISTINCT user_id)                                                   AS users,
  SUM(quantity)                                                             AS quantity,
  SUM(f_sales_new.local_currency_net_sales * COALESCE(usd.rate, usd2.rate)) AS usd
FROM
  f_sales_new
  JOIN d_utc_sales_date ON d_utc_sales_date.utc_sales_date_key = f_sales_new.utc_sales_date_key
  JOIN d_offers ON d_offers.offer_key = f_sales_new.offer_key
  JOIN d_users ON d_users.user_key = f_sales_new.user_key
  JOIN d_currencies ON d_currencies.currency_key = f_sales_new.currency_key :: INTEGER
  LEFT JOIN currency_fixed_rate usd ON
    REPLACE(usd.payment_period, '-', '') = LEFT(f_sales_new.sales_settlement_period_key :: TEXT, 6)
    AND usd.currency_from = d_currencies.currency_code
    AND usd.currency_to = 'USD'
  LEFT JOIN (
              SELECT *
              FROM currency_fixed_rate
              WHERE payment_period = (SELECT MAX(payment_period) FROM currency_fixed_rate)
            ) usd2 ON
    usd2.currency_from = d_currencies.currency_code
    AND usd2.currency_to = 'USD'
WHERE 1=1
   AND utc_sales_year IN ('2015', '2014')
GROUP BY
  utc_sales_month,
  utc_sales_year,
  utc_sales_month_name,
  offer_purchase_plan
;


SELECT
  utc_sales_month,
  utc_sales_month_name,
  utc_sales_year,
  CASE
    WHEN offer_purchase_plan = 'Single' THEN 1
    WHEN offer_purchase_plan = 'Subscription' THEN 2
    WHEN offer_purchase_plan = 'Buffet' THEN 3
    WHEN offer_purchase_plan = 'Bundle' THEN 4
    END AS id_offer_purchase_plan,
  offer_purchase_plan,
  CASE
  WHEN TO_CHAR(user_joined_date, 'YYYYMM') :: INT <> utc_sales_month_key
    THEN 'Return Users'
  ELSE 'New Users'
  END                                                                       AS user_type,
  COUNT(DISTINCT user_id)                                                   AS users,
  SUM(quantity)                                                             AS quantity,
  SUM(f_sales_new.local_currency_net_sales * COALESCE(usd.rate, usd2.rate)) AS usd
FROM
  f_sales_new
  JOIN d_utc_sales_date ON d_utc_sales_date.utc_sales_date_key = f_sales_new.utc_sales_date_key
  JOIN d_offers ON d_offers.offer_key = f_sales_new.offer_key
  JOIN d_users ON d_users.user_key = f_sales_new.user_key
  JOIN d_currencies ON d_currencies.currency_key = f_sales_new.currency_key :: INT
  LEFT JOIN currency_fixed_rate usd ON
    REPLACE(usd.payment_period, '-', '') = LEFT(f_sales_new.sales_settlement_period_key :: TEXT, 6)
    AND usd.currency_from = d_currencies.currency_code
    AND usd.currency_to = 'USD'
  LEFT JOIN (
              SELECT *
              FROM currency_fixed_rate
              WHERE payment_period = (SELECT MAX(payment_period) FROM currency_fixed_rate)
            ) usd2 ON
    usd2.currency_from = d_currencies.currency_code
    AND usd2.currency_to = 'USD'
WHERE
  utc_sales_year IN (2014, 2015)
GROUP BY
  utc_sales_month,
  utc_sales_month_name,
  utc_sales_year,
  user_type,
  offer_purchase_plan
ORDER BY
  utc_sales_month DESC;