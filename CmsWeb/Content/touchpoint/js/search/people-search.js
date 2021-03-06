﻿$(function () {
    function initializePopovers() {
        $('[data-toggle="popover"]').popover({ html: true });
        $('[data-toggle="popover"]').click(function (ev) {
            ev.preventDefault();
        });
    }

    $('#name').focus();

    $("#searchvalues select").not("#statusflags").css("width", "100%");

    $("#clear").click(function (ev) {
        ev.preventDefault();
        $("input:text").val("");
        $("#memberstatus,#campus").val(0); //.sb("refresh");
        $("#gender,#marital").val(99); //.sb("refresh");
        $('#statusflags').multiselect('deselectAll', false);
        $('#statusflags').multiselect('updateButtonText');
        return false;
    });

    $("#search").click(function (ev) {
        ev.preventDefault();
        $.getTable();
        return false;
    });

    $("a.bt").bind("contextmenu", function (e) {
        e.preventDefault();
    });

    $('#statusflags').multiselect();

    $("#convert").click(function (ev) {
        ev.preventDefault();
        var f = $('#results').closest('form');
        var q = f.serialize();
        $.post($('#convert').attr('href'), q, function (ret) {
            if (ret.startsWith("/"))
                window.location = ret;
            else {
                $.block(ret);
                $('.blockOverlay').attr('title', 'Click to unblock').click($.unblock);
            }
        });
        return false;
    });

    $.gotoPage = function(e, pg) {
        $("#Page").val(pg);
        $.getTable();
        return false;
    };

    $.setPageSize = function (e) {
        $('#Page').val(1);
        $("#PageSize").val($(e).val());
        return $.getTable();
    };

    $.getTable = function () {
        var f = $('#results').closest('form');
        var q = f.serialize();
        $.block();
        $.post($('#search').attr('href'), q, function (ret) {
            $('#results').replaceWith(ret).ready(function () {
                $("#totalcount").text($("#totcnt").val());
                initializePopovers();
                $.unblock();
            });
        });

        return false;
    };

    $('body').on('click', '#resultsTable > thead a.sortable', function (ev) {
        ev.preventDefault();
        var newsort = $(this).text();
        var sort = $("#Sort");
        var dir = $("#Direction");
        if ($(sort).val() == newsort && $(dir).val() == 'asc')
            $(dir).val('desc');
        else
            $(dir).val('asc');
        $(sort).val(newsort);
        $.getTable();
        return false;
    });

    $("form").on("keypress", 'input', function (e) {
        if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
            $('#search').click();
            return false;
        }
        return true;
    });

    $('body').on('click', 'a.taguntag', function (ev) {
        ev.preventDefault();
        $.block();
        var a = $(this);
        $.post('/Tags/ToggleTag/' + $(this).attr('value'), null, function (ret) {
            var link = $(ev.target).closest('a');
            link.removeClass('btn-default').removeClass('btn-success');
            link.addClass(ret == "Remove" ? "btn-default" : "btn-success");
            link.html(ret == "Remove" ? "<i class='fa fa-tag'></i> Remove" : "<i class='fa fa-tag'></i> Add");
            $.unblock();
        });
        return false;
    });

    initializePopovers();
});