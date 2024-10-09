
-- json字符函数
DESC FUNCTION get_json_object ;
-- get_json_object(json_txt, path) - Extract a json object from path

WITH t1 AS (
    SELECT '{"id": 1001, "name": "萱萱", "height": 1.23}' AS str
)
SELECT
    str,
    get_json_object(str, '$.id') AS id,
    get_json_object(str, '$.name') AS name,
    get_json_object(str, '$.height') AS height
FROM t1
;


-- 使用
WITH t1 AS (
    SELECT
        '[{"name":"大郎","sex":"男","age":"25"},{"name":"西门庆","sex":"男","age":"47"}]' AS json_array
)
SELECT
    json_array,
    -- 获取数组Array中第一个元素值
    get_json_object(json_array, '$[0]') AS first_json_str,
    -- 获取json中name,sex,age字段值
    get_json_object(json_array, '$[0].name') AS first_name,
    get_json_object(json_array, '$[0].sex') AS first_sex,
    get_json_object(json_array, '$[0].age') AS first_age,
    -- 获取数组Array中第二个元素值
    get_json_object(json_array, '$[1]') AS second_json_str,
    get_json_object(json_array, '$[1].name') AS second_name,
    get_json_object(json_array, '$[1].sex') AS second_sex,
    get_json_object(json_array, '$[1].age') AS second_age
FROM t1
;