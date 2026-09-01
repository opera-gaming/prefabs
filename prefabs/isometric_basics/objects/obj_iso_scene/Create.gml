var _cfg = isometric_basics_tuning();

// Origin sits top-centre so the diamond fans out below it.
iso = ::iso::iso_make(_cfg.tile_w, _cfg.tile_h,
    ::kernel::kernel_gui_width() / 2, 90);

hover = { col: -1, row: -1 };
