CREATE OR REPLACE FUNCTION recherche(keyword text)
RETURNS TABLE (crawl_id uuid, score double precision) AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id AS crawl_id,
        s.score
    FROM
        "mia.ben-redjeb.1@ens.etsmtl.ca"."score" s
    JOIN louis_v005.crawl c ON s.crawl_id = c.id
    JOIN louis_v005.html_content h ON c.md5hash = h.md5hash
    WHERE
        h.content LIKE '%' || keyword || '%'
    ORDER BY s.score DESC
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;

select * from recherche('documents') 