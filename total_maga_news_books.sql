SELECT
    count( DISTINCT core_items.name) as magazines
FROM
  core_items
WHERE
  1=1
  AND core_items.itemtype_id = 1
  AND is_active = 'T'
UNION
SELECT
    count(DISTINCT core_items.name) as books
FROM
  core_items
WHERE
  1=1
  AND core_items.itemtype_id = 2
  AND is_active = 'T'
UNION
  SELECT
    count(DISTINCT core_items.name) as newspapers
FROM
  core_items
WHERE
  1=1
  AND core_items.itemtype_id = 3;
  AND is_active = 'T'

--vendor
SELECT count (DISTINCT core_vendors.name) from core_vendors;



--content
SELECT
  count(DISTINCT core_items.name)
FROM
  core_items
WHERE 1=1
  AND core_items.is_active = 'T'
LIMIT 10;

--title
SELECT
  count (DISTINCT core_brands.name)
FROM
  core_brands
WHERE 1=1
  AND core_brands.is_active = 'T';





