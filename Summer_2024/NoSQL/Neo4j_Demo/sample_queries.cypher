// =====================================================================================================================
// Physiology Queries. Bar charts.
// =====================================================================================================================
// Bar chart for the number of batches and proportions
CALL {
    MATCH (p:ProcessOrder)-[:MADE_FROM]->(b:Batch)
    WHERE b.species = $neodash_batch_species
        AND ($neodash_batch_mega_segment = 'ALL' OR b.mega_segment = $neodash_batch_mega_segment)
        AND ($neodash_batch_variety_name = 'ALL' OR b.variety_name = $neodash_batch_variety_name)
        AND ($neodash_batch_plant_id = 'ALL' OR b.plant_id = $neodash_batch_plant_id)
        AND ($neodash_quality_status = 'ALL' OR b.init_quality_status = $neodash_quality_status)
        AND b.harvest_year IN $neodash_years_for_comparison_4
        AND ('ALL' IN $neodash_origins_for_comparison_4 OR b.origin_country IN $neodash_origins_for_comparison_4)
        AND EXISTS(()-[:INSPECTED]->(b))
        AND p.process_order_type_id IN ['ZP01', 'ZP14' , 'ZP15']
        AND b.material_group = 'COM300' AND b.existing_inventory_flag = true
    RETURN b.batch_id AS batch_id, b.origin_country AS origin_country, toFloat(b[$neodash_test_method_4]) AS test_method

    UNION

    MATCH (p:ProcessOrder)-[:MADE_FROM]->(b:Batch)<-[:INSPECTED]-(i:InspectionLot)
    WHERE b.species = $neodash_batch_species
        AND ($neodash_batch_mega_segment = 'ALL' OR b.mega_segment = $neodash_batch_mega_segment)
        AND ($neodash_batch_variety_name = 'ALL' OR b.variety_name = $neodash_batch_variety_name)
        AND ($neodash_batch_plant_id = 'ALL' OR b.plant_id = $neodash_batch_plant_id)
        AND ($neodash_quality_status = 'ALL' OR b.init_quality_status = $neodash_quality_status)
        AND b.harvest_year IN $neodash_years_for_comparison_4
        AND ('ALL' IN $neodash_origins_for_comparison_4 OR b.origin_country IN $neodash_origins_for_comparison_4)
        AND p.process_order_type_id IN ['ZP01', 'ZP14' , 'ZP15']
        AND b.material_group IN ['COM500', 'COM510']
        AND b.system_goods_receipt_date <> '0'
        AND i.end_date_of_the_inspection <= date(datetime({epochmillis: apoc.date.parse(b.
          system_goods_receipt_date, 'ms', 'yyyyMMdd')})) + duration('P5M')
    RETURN b.batch_id AS batch_id, b.origin_country AS origin_country, avg(toFloat(i[$neodash_test_method_4])) AS test_method
}
WITH CASE
       WHEN test_method >= 0.0 AND test_method <= 70.0 THEN '0%≤, ≤70%'
       WHEN test_method > 70.0 AND test_method <= 75.0 THEN '70%<, ≤75%'
       WHEN test_method > 75.0 AND test_method <= 80.0 THEN '75%<, ≤80%'
       WHEN test_method > 80.0 AND test_method <= 85.0 THEN '80%<, ≤85%'
       WHEN test_method > 85.0 AND test_method <= 90.0 THEN '85%<, ≤90%'
       WHEN test_method > 90.0 AND test_method <= 95.0 THEN '90%<, ≤95%'
       WHEN test_method > 95.0 AND test_method <= 100.0 THEN '95%<, ≤100%'
       ELSE null
    END AS threshold_bin,
    origin_country,
    count(DISTINCT batch_id) AS batch_count
WHERE threshold_bin IS NOT NULL

WITH origin_country, threshold_bin, batch_count

// Calculate the total number of batches per origin country
CALL {
    CALL {
        MATCH (p:ProcessOrder)-[:MADE_FROM]->(b:Batch)
        WHERE b.species = $neodash_batch_species
            AND ($neodash_batch_mega_segment = 'ALL' OR b.mega_segment = $neodash_batch_mega_segment)
            AND ($neodash_batch_variety_name = 'ALL' OR b.variety_name = $neodash_batch_variety_name)
            AND ($neodash_batch_plant_id = 'ALL' OR b.plant_id = $neodash_batch_plant_id)
            AND ($neodash_quality_status = 'ALL' OR b.init_quality_status = $neodash_quality_status)
            AND b.harvest_year IN $neodash_years_for_comparison_4
            AND ('ALL' IN $neodash_origins_for_comparison_4 OR b.origin_country IN $neodash_origins_for_comparison_4)
            AND EXISTS(()-[:INSPECTED]->(b))
            AND p.process_order_type_id IN ['ZP01', 'ZP14' , 'ZP15']
            AND b.material_group = 'COM300' AND b.existing_inventory_flag = true
        RETURN b.batch_id AS batch_id, b.origin_country AS origin_country, toFloat(b[$neodash_test_method_4]) AS test_method

        UNION

        MATCH (p:ProcessOrder)-[:MADE_FROM]->(b:Batch)<-[:INSPECTED]-(i:InspectionLot)
        WHERE b.species = $neodash_batch_species
            AND ($neodash_batch_mega_segment = 'ALL' OR b.mega_segment = $neodash_batch_mega_segment)
            AND ($neodash_batch_variety_name = 'ALL' OR b.variety_name = $neodash_batch_variety_name)
            AND ($neodash_batch_plant_id = 'ALL' OR b.plant_id = $neodash_batch_plant_id)
            AND ($neodash_quality_status = 'ALL' OR b.init_quality_status = $neodash_quality_status)
            AND b.harvest_year IN $neodash_years_for_comparison_4
            AND ('ALL' IN $neodash_origins_for_comparison_4 OR b.origin_country IN $neodash_origins_for_comparison_4)
            AND p.process_order_type_id IN ['ZP01', 'ZP14' , 'ZP15']
            AND b.material_group IN ['COM500', 'COM510']
            AND b.system_goods_receipt_date <> '0'
            AND i.end_date_of_the_inspection <= date(datetime({epochmillis: apoc.date.parse(b.
              system_goods_receipt_date, 'ms', 'yyyyMMdd')})) + duration('P5M')
        RETURN b.batch_id AS batch_id, b.origin_country AS origin_country, avg(toFloat(i[$neodash_test_method_4])) AS test_method
    }
    WITH batch_id, origin_country, test_method
    WHERE test_method IS NOT NULL
    RETURN
        origin_country AS origin_country2,
        count(DISTINCT batch_id) AS total_batches2
}
WITH origin_country, origin_country2, threshold_bin, batch_count, total_batches2
WHERE origin_country = origin_country2
RETURN origin_country, threshold_bin, total_batches2, sum((batch_count * 100.0 / total_batches2)) AS percentage
ORDER BY total_batches2 DESC, threshold_bin DESC;
