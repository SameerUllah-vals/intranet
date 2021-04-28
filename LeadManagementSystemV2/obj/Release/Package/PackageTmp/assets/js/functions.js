if ($('.record-table').length > 0) {
    $.fn.dataTableExt.oApi.fnStandingRedraw = function (oSettings) {
        //redraw to account for filtering and sorting
        // concept here is that (for client side) there is a row got inserted at the end (for an add)
        // or when a record was modified it could be in the middle of the table
        // that is probably not supposed to be there - due to filtering / sorting
        // so we need to re process filtering and sorting
        // BUT - if it is server side - then this should be handled by the server - so skip this step
        if (oSettings.oFeatures.bServerSide === false) {
            var before = oSettings._iDisplayStart;
            oSettings.oApi._fnReDraw(oSettings);
            //iDisplayStart has been reset to zero - so lets change it back
            oSettings._iDisplayStart = before;
            oSettings.oApi._fnCalculateEnd(oSettings);
        }
        //draw the 'current' page
        oSettings.oApi._fnDraw(oSettings);
    };
    $.fn.dataTableExt.oApi.fnSetFilteringDelay = function (oSettings, iDelay) {
        var _that = this;
        if (iDelay === undefined) {
            iDelay = 250;
        }
        this.each(function (i) {
            if (typeof _that.fnSettings().aanFeatures.f !== 'undefined') {
                $.fn.dataTableExt.iApiIndex = i;
                var
                    oTimerId = null,
                    sPreviousSearch = null,
                    anControl = $('input', _that.fnSettings().aanFeatures.f);

                anControl.unbind('keyup search input').bind('keyup search input', function () {
                    if (sPreviousSearch === null || sPreviousSearch != anControl.val()) {
                        window.clearTimeout(oTimerId);
                        sPreviousSearch = anControl.val();
                        oTimerId = window.setTimeout(function () {
                            $.fn.dataTableExt.iApiIndex = i;
                            _that.fnFilter(anControl.val());
                        }, iDelay);
                    }
                });
                return this;
            }
        });
        return this;
    };
}
var minTwoDigits = function (n) {
    return (n < 10 ? '0' : '') + n;
}
var isValidURL = function (_Value) {
    if (_Value == "#") {
        return true;
    } else {
        var urlregex = new RegExp(
            "^(http:\/\/www.|https:\/\/www.|ftp:\/\/www.|www.){1}([0-9A-Za-z]+\.)");
        return urlregex.test(_Value);
    }
}
var GetQueryStringParams = function (sParam) {
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++) {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) {
            return sParameterName[1];
        }
    }
}
var delay = (function () {
    var timer = 0;
    return function (callback, ms) {
        clearTimeout(timer);
        timer = setTimeout(callback, ms);
    };
})();
var scrollToPosition = function (elem) {
    jQuery('html, body').stop().animate({
        'scrollTop': elem.offset().top - 100
    }, 500, 'swing', function () {
        //window.location.hash = target;

    });
}
var RemoveCharacter = function (output, limit) {
    return output.substr(0, output.length - limit);
}
var GenerateRandomValue = function (length, is_discount) {
    var chars = "abcdefghijklmnopqrstuvwxyz";
    if (!is_discount) {
        chars += "ABCDEFGHIJKLMNOP1234567890";
    }
    var pass = "";
    for (var x = 0; x < length; x++) {
        var i = Math.floor(Math.random() * chars.length);
        pass += chars.charAt(i);
    }
    return pass;
}
$(document).on("click", "a", function () {
    if ($(this).hasClass("disabled")) {
        return false;
    }
});
var DisableView = function () {
    $('form').each(function () {
        let form = $(this)
         let x = form.hasClass("enableAttribute");
        if (!x) {
            form.find("input[type='text'],input[type='password'],textarea,input[type='checkbox'],input[type='email'],input[type='date'],input[type='number'],input[type='time'],input[type='radio'],select").each(function () {
                $(this).attr("disabled", "disabled");
                $(this).removeAttr("action");
            });
            form.find("button").remove();
        }
    });
    
   
    //$('#statusForm').find("input[type='text'],input[type='password'],textarea,input[type='checkbox'],input[type='email'],input[type='date'],input[type='number'],input[type='time'],input[type='radio'],select").each(function () {
    //    $(this).removeAttr("disabled");
    //});
}
var EnableDisableArea = function (area, object_type) {
    var main_context = $('form');
    if (area != "") {
        main_context = $(area);
    }
    if (object_type == "Disable") {
        main_context.find("submit,button,input[type='checkbox'],input[type='radio'],select").each(function () {
            $(this).attr("disabled", "disabled");
        });
        main_context.find("input[type='text'],input[type='password'],textarea").each(function () {
            $(this).attr("readonly", "readonly");
        });
        main_context.find("a").each(function () {
            $(this).addClass("disabled");
        });
        $("#loading").show();
    } else {
        main_context.find("input[type='text'],input[type='password'],textarea").each(function () {
            $(this).removeAttr("readonly");
        });
        main_context.find("a").each(function () {
            $(this).removeClass("disabled");
        });
        main_context.find("submit,button,input[type='checkbox'],input[type='radio'],select").each(function () {
            $(this).removeAttr("disabled");
        });
        $("#loading").hide();
    }
}
OnFormBegin = function () {
    EnableDisableArea("", "Disable");
}
OnFormComplete = function () {
    EnableDisableArea("", "Enable");
}
OnFormFailure = function (response) {
    EnableDisableArea("", "Enable");
    console.log(response);
    $("#loading").hide();
}
OnFormSuccess = function (response) {
    console.log(response);
    debugger;
    var responseTypeArray = response.Type.split('-');
    //$.each(responseTypeArray, function (key, value) {
    //    if (value == "M") {
    //        if (response.Success == true) {
    //            if ($(".msg-area").length > 0) {
    //                $(".msg-area").notify(
    //                    response.Message,
    //                    { position: "bottom", className: "success" }
    //                );
    //            } else if ($("#btn_back").length > 0) {
    //                $("#btn_back").notify(
    //                    response.Message,
    //                    { position: "left", className: "success" }
    //                );
    //            } else {
    //                $.notify(response.Message, "success");
    //            }  
    //        } else {
    //            if ($(".msg-area").length > 0) {
    //                $(".msg-area").notify(
    //                    response.Message,
    //                    { position: "bottom", className: "error" }
    //                );
    //            } else if ($("#btn_back").length > 0) {
    //                $("#btn_back").notify(
    //                    response.Message,
    //                    { position: "left", className: "error" }
    //                );
    //            } else {
    //                $.notify(response.Message, { position: "left", className: "error" });
    //            }
    //        }
    //    }
    //    else if (value == "F") {
    //        if (response.Success == true) {
    //            $("#" + response.FieldName).notify(
    //                response.Message,
    //                { position: "bottom", className: "success" }
    //            );
    //        } else {
    //            $("#" + response.FieldName).notify(
    //                response.Message,
    //                { position: "bottom", className: "error" }
    //            );
    //        }
    //    }else if (value == "R") {
    //        $('form')[0].reset();
    //    } else if (value == "T") {
    //        window.location = response.TargetURL;
    //    } else if (value == "TD") {
    //        setTimeout(function () {
    //            window.location = response.TargetURL;
    //        }, 2000);
    //    } else if (value == "RL") {
    //        window.location.reload();
    //    } else if (value == "RLD") {
    //        setTimeout(function () {
    //            window.location.reload();
    //        }, 2000);
    //    }
    //});
    for (var i = 0; i < responseTypeArray.length; i++) {
        let value = responseTypeArray[i];
        if (value == "M") {
            if (response.Success == true) {
                if ($(".msg-area").length > 0) {
                    $(".msg-area").notify(
                        response.Message,
                        { position: "bottom", className: "success" }
                    );
                } else if ($("#btn_back").length > 0) {
                    $("#btn_back").notify(
                        response.Message,
                        { position: "left", className: "success" }
                    );
                } else {
                    $.notify(response.Message, "success");
                }
            } else {
                if ($(".msg-area").length > 0) {
                    $(".msg-area").notify(
                        response.Message,
                        { position: "bottom", className: "error" }
                    );
                } else if ($("#btn_back").length > 0) {
                    $("#btn_back").notify(
                        response.Message,
                        { position: "left", className: "error" }
                    );
                } else {
                    $.notify(response.Message, "error");
                }
            }
        }
        else if (value == "F") {
            if (response.Success == true) {
                $("#" + response.FieldName).notify(
                    response.Message,
                    { position: "bottom", className: "success" }
                );
            } else {
                $("#" + response.FieldName).notify(
                    response.Message,
                    { position: "bottom", className: "error" }
                );
            }
        } else if (value == "R") {
            $('form')[0].reset();
        } else if (value == "T") {
            window.location = response.TargetURL;
        } else if (value == "TD") {
            setTimeout(function () {
                window.location = response.TargetURL;
            }, 2000);
        } else if (value == "RL") {
            window.location.reload();
        } else if (value == "RLD") {
            setTimeout(function () {
                window.location.reload();
            }, 2000);
        }
    }
    EnableDisableArea("", "Enable");    

}
$(document).on("click", ".remove-row", function () {
    var current_context = $(this);
    $.confirm({
        title: 'Confirmation',
        content: 'Are you sure you want to delete ?',
        animation: 'scale',
        closeAnimation: 'scale',
        opacity: 0.5,
        buttons: {
            confirm: {
                text: 'Yes',
                btnClass: 'btn-danger',
                action: function () {
                    var dialog_box = $.dialog({
                        title: 'Wait',
                        content: 'Processing ...',
                        animation: 'scale',
                        onOpen: function () {
                            var that = this;
                            var oTable = $('.record-table').dataTable();
                            jQuery.ajax({
                                type: "POST",
                                url: current_context.attr("href"),
                                data: "_value=" + current_context.attr("data-id"),
                                success: function (response) {
                                    that.setContent(response.Message);
                                    setTimeout(function () {
                                        dialog_box.close();
                                    }, 2000);
                                    if (response.Success == true) {
                                        oTable.fnStandingRedraw();
                                    }
                                },
                                error: function (data) {
                                    console.log(data);
                                    dialog_box.close();
                                }
                            });
                        }
                    });
                }
            },
            no: function () {
            }
        }
    });
    return false;
});

$(document).on("click", ".remove-image", function () {
    var current_context = $(this);
    $.confirm({
        title: 'Confirmation',
        content: 'Are you sure you want to delete ?',
        animation: 'scale',
        closeAnimation: 'scale',
        opacity: 0.5,
        buttons: {
            confirm: {
                text: 'Yes',
                btnClass: 'btn-danger',
                action: function () {
                    var dialog_box = $.dialog({
                        title: 'Wait',
                        content: 'Processing ...',
                        animation: 'scale',
                        onOpen: function () {
                            var that = this;
                            jQuery.ajax({
                                type: "POST",
                                url: current_context.attr("href"),
                                data: "_value=" + current_context.attr("data-id"),
                                success: function (response) {
                                    that.setContent(response.Message);
                                    setTimeout(function () {
                                        dialog_box.close();
                                    }, 2000);
                                    window.location.reload();
                                },
                                error: function (data) {
                                    console.log(data);
                                    dialog_box.close();
                                }
                            });
                        }
                    });
                }
            },
            no: function () {
            }
        }
    });
    return false;
});
var OnlyNumber = function () {
    if ($('.only-number').length > 0) {
        $('.only-number').keypress(function (event) {
            if (event.keyCode != 0) {
                var regex = new RegExp("^[0-9.]+$");
                var key = String.fromCharCode(!event.keyCode ? event.which : event.keyCode);
                var enter = (!event.keyCode ? event.which : event.keyCode);
                if ((!regex.test(key)) && (enter != 13)) {
                    event.preventDefault();
                    return false;
                }
            }
        });
        $(".only-number").bind("paste", function (e) {
            e.preventDefault();
        });
    }
}
$(document).ready(function () {
    if ($(".date-picker").length > 0) {
        $(".date-picker").datepicker({ autoclose: true, orientation: "bottom auto" });
    }
    if ($(".select-picker").length > 0) {
        $(".select-picker").select2();
    }
    if ($(".select-picker").length > 0) {
        $(".select-picker").select2();
    }
    if ($(".auto-numeric").length > 0) {
        $('.auto-numeric').autoNumeric('init');
    }
    OnlyNumber();
    if ($('.not-zero').length > 0) {
        $('.not-zero').keyup(function () {
            var value = $(this).val();
            if (value == "" || value.indexOf('0') == 0) {
                $(this).val(1);
            }
        });
        $('.not-zero').focusout(function () {
            var value = $(this).val();
            if (value == "" || value == "0") {
                $(this).val(1);
            }
        });
    }
});


