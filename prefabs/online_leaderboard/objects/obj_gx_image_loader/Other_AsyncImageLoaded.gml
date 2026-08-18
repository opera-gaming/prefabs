var response = json_parse(json_encode(async_load));
if (response.id == request_id) { //gmx-lint-ignore
    var img = response.http_status == 200 ? response.id : default_image;
    callback(response.http_status, img, id);
    instance_destroy();
}
