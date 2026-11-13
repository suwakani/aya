#pragma once

#include <aya.h>
#define RAPIDJSON_NOMEMBERITERATORCLASS
#include <rapidjson/document.h>

// NOTE: ditch rapidjson once we get the time

namespace aya::util {
	auto json_loadFile(std::string src_filename) -> rapidjson::Document;
};

