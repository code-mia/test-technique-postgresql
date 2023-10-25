CREATE OR REPLACE VIEW "mia.ben-redjeb.1@ens.etsmtl.ca"."score" as 
SELECT
    c.id AS crawl_id,
    PERCENT_RANK() OVER (ORDER BY LENGTH(h.content)) AS score
FROM louis_v005.crawl c
JOIN louis_v005.html_content h ON c.md5hash = h.md5hash;