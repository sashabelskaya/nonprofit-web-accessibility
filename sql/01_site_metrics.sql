-- Inspect the live schema and dry-run before execution.
-- Set maximum bytes billed in your query settings.
-- Partition date is the monthly label, not the exact test timestamp.
SELECT
  date,
  page,
  ROUND(SAFE_CAST(JSON_VALUE(summary, '$.bytesTotal') AS FLOAT64) / 1000000, 2) AS total_mb,
  ROUND(SAFE_CAST(JSON_VALUE(summary, '$.bytesImg') AS FLOAT64) / 1000000, 2) AS images_mb,
  ROUND(SAFE_CAST(JSON_VALUE(summary, '$.bytesFont') AS FLOAT64) / 1000000, 2) AS fonts_mb,
  ROUND(SAFE_CAST(JSON_VALUE(summary, '$.bytesJS') AS FLOAT64) / 1000000, 2) AS javascript_mb,
  ROUND(SAFE_CAST(JSON_VALUE(lighthouse, '$.categories.accessibility.score') AS FLOAT64) * 100, 0) AS accessibility_score,
  JSON_VALUE(lighthouse, '$.audits."image-alt".score') AS image_alt_score,
  JSON_VALUE(lighthouse, '$.audits."button-name".score') AS button_name_score,
  JSON_VALUE(lighthouse, '$.audits."color-contrast".score') AS contrast_score,
  JSON_VALUE(lighthouse, '$.audits."label".score') AS form_label_score,
  JSON_VALUE(lighthouse, '$.audits.label.scoreDisplayMode') AS form_label_status,
  ARRAY_TO_STRING(ARRAY(SELECT DISTINCT t.technology FROM UNNEST(technologies) AS t WHERE 'CMS' IN UNNEST(t.categories) ORDER BY t.technology), ', ') AS cms
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
ORDER BY total_mb DESC;
