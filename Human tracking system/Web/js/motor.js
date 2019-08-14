var loc = 0;
var peek_count = 0;
var valley_count = 0;
var slide1 = 'http://192.168.1.104';
var slide2 = 'http://192.168.1.101';

function moveto(tar) {
    var dif = loc - tar;
    if (dif == 0) {
        $("#currentLocation").html(tar);
    } else if (dif > 0) {
        $.get(slide1 + "/move/0/" + dif + '/', function(result) {});
        $.get(slide2 + "/move/0/" + dif + '/', function(result) {});
        loc = tar;
        $("#currentLocation").html(tar);
    } else {
        $.get(slide1 + "/move/1/" + (-dif) + '/', function(result) {});
        $.get(slide2 + "/move/1/" + (-dif) + '/', function(result) {});
        loc = tar;
        $("#currentLocation").html(tar);
    }
}

function moveup() {
    $.get(slide1 + "/move/1/1/", function(result) {});
    $.get(slide2 + "/move/1/1/", function(result) {});
    loc = loc + 1;
    console.log(loc);
    $("#currentLocation").html(loc);
}

function movedown() {
    $.get(slide1 + "/move/0/1/", function(result) {});
    $.get(slide2 + "/move/0/1/", function(result) {});
    loc = loc - 1;
    console.log(loc);
    $("#currentLocation").html(loc);
}

function reset() {
    moveto(0);
    peek_count = 0;
    valley_count = 0;
    $("#peek").html('');
    $("#valley").html('');
}
