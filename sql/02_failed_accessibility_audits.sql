-- Inspect the live schema and dry-run before execution.
-- Set maximum bytes billed in your query settings.
-- Partition date is the monthly label, not the exact test timestamp.
WITH selected_pages AS (
 SELECT date, page, lighthouse
 FROM `httparchive.crawl.pages`
 WHERE date = '2026-10-01'
  AND client = 'mobile'
  AND is_root_page = TRUE
  AND page IN (
    'https://www.drk.de/',
    'https://www.lebenshilfe.de/',
    'https://www.johanniter.de/',
    'https://www.caritas.de/',
    'https://www.der-paritaetische.de/',
    'https://www.diakonie.de/',
    'https://www.tafel.de/',
    'https://awo.org/',
    'https://www.malteser.de/',
    'https://www.aktion-mensch.de/'
  )
), checks AS (
 SELECT date, page,
 JSON_VALUE(lighthouse, '$.fetchTime') AS tested_at,
 JSON_VALUE(lighthouse, '$.lighthouseVersion') AS lighthouse_version,
 JSON_VALUE(ref, '$.id') AS audit_id,
 JSON_VALUE(ref, '$.group') AS audit_group,
 lighthouse
 FROM selected_pages
 CROSS JOIN UNNEST(JSON_QUERY_ARRAY(lighthouse, '$.categories.accessibility.auditRefs')) AS ref
), details AS (
 SELECT date, page, tested_at, lighthouse_version, audit_id, audit_group,
 lighthouse['audits'][audit_id] AS audit
 FROM checks
)
SELECT date, page, tested_at, lighthouse_version, audit_id, audit_group,
 JSON_VALUE(audit, '$.title') AS title,
 JSON_VALUE(audit, '$.description') AS description,
 JSON_VALUE(audit, '$.scoreDisplayMode') AS score_mode,
 JSON_QUERY(audit, '$.details') AS details
FROM details
WHERE SAFE_CAST(JSON_VALUE(audit, '$.score') AS FLOAT64) = 0
ORDER BY audit_id, page;
