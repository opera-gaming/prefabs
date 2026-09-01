// Attachments a pack hangs off this actor, keyed by pack name. A pack
// writes its own slot and reads only its own, which is what lets four
// packs share one instance without a parent chain.
attachments = {};

/// @function attach(pack, config)
attach = function(pack, config) {
    attachments[$ pack] = config;
    return config;
};

/// @function attachment(pack)
attachment = function(pack) {
    if (!variable_struct_exists(attachments, pack)) return undefined;
    return attachments[$ pack];
};
