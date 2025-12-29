const std = @import("std");
const rfc = @import("rfc");

const W = std.unicode.utf8ToUtf16LeStringLiteral;

pub fn main() !void {
    var login_params: [6]rfc.connection.Parameter = undefined;
    var error_info: rfc.ErrorInfo = undefined;

    login_params[0].name = W("ashost");
    login_params[0].value = W("e.g. IP");
    login_params[1].name = W("sysnr");
    login_params[1].value = W("##");
    login_params[2].name = W("client");
    login_params[2].value = W("###");
    login_params[3].name = W("user");
    login_params[3].value = W("...");
    login_params[4].name = W("passwd");
    login_params[4].value = W("...");

    var connection = rfc.connection.RfcOpenConnection(&login_params, 5, &error_info) orelse {
        try rfc.PrintErrorToLog(&error_info);
        return;
    };
    var function_descr = connection.GetFunctionDesc(W("ZIG_RFC_ADD"), &error_info) orelse {
        try rfc.PrintErrorToLog(&error_info);
        return;
    };
    var function = function_descr.CreateFunction(&error_info) orelse {
        try rfc.PrintErrorToLog(&error_info);
        return;
    };

    const x: rfc.commons.Int = 1;
    const y: rfc.commons.Int = 2;

    //Set parameters
    if (function.SetInt(W("X"), x, &error_info) != .ok) {
        try rfc.PrintErrorToLog(&error_info);
    }
    if (function.SetInt(W("Y"), y, &error_info) != .ok) {
        try rfc.PrintErrorToLog(&error_info);
    }

    //Invoke at application server
    if (connection.Invoke(function, &error_info) != .ok) {
        try rfc.PrintErrorToLog(&error_info);
    }

    //Get exporting parameters
    var sum: rfc.commons.Int = undefined;
    if (function.GetInt(W("SUM"), &sum, &error_info) != .ok) {
        try rfc.PrintErrorToLog(&error_info);
    }

    std.debug.print("{d} + {d} = {d}", .{ x, y, sum });
}
