var csi_id = 1;
var windowNum = 1;
var breathRate = 0;
var detect = 1;
//var ifupdateRate;

/* init chart! */
var windowLength = 20 * 20;
var chart1 = echarts.init(document.getElementById('chart1'));
var chart2 = echarts.init(document.getElementById('chart2'));
/*var Chart5 = echarts.init(document.getElementById('chart_area5'));
var Chart6 = echarts.init(document.getElementById('chart_area6'));*/
var timeIndex = [];
var Data_buffer = new Array();
for (var j = 0; j < windowNum; j++) {
    Data_buffer[j] = new Array();
}

var ampData = new Array();
for (var j = 0; j < windowNum; j++) {
    ampData[j] = new Array();
}

for (var i = 0; i < windowLength; i++) {
    this_time = (i / windowLength - 1) * 20;
    timeIndex.push(this_time.toFixed(2));
    for (var j = 0; j < windowNum; j++) {
        ampData[j].push(0);
    }
};
var option1 = {
    title: {
        text: 'Time Domain',
        left: 'center',
        textStyle: {
            fontSize: 22,
        }
    },
    tooltip: {},
    xAxis: {
        name: 'Time',
        data: timeIndex,
        axisLabel: {
            textStyle: {
                fontSize: 16,
            }
        },
        nameTextStyle: {
            fontSize: 18,
            fontWeight: 'bold',
        },
        nameLocation: 'middle',
        nameGap: 28,
    },
    yAxis: {
        name: 'Amplitude',
        min: 0,
        max: 12,
        axisLabel: {
            textStyle: {
                fontSize: 16,
            }
        },
        nameTextStyle: {
            fontSize: 18,
            fontWeight: 'bold',
        },
        value: 'value',
    },
    series: [{
        name: 'amplitude',
        type: 'line',
        data: ampData[0]
    }]
};
var option2 = {
    title: {
        text: 'Frequency Domain',
        left: 'center',
        textStyle: {
            fontSize: 22,
            fontWeight: 'bold',
        }
    },
    tooltip: {},
    xAxis: {
        name: 'Frequency',
        data: timeIndex,
        axisLabel: {
            textStyle: {
                fontSize: 16,
            }
        },
        nameTextStyle: {
            fontSize: 18,
            fontWeight: 'bold',
        },
        nameLocation: 'middle',
        nameGap: 28,
    },
    yAxis: {
        name: 'Power',
        min: 0,
        max: 12,
        axisLabel: {
            textStyle: {
                fontSize: 16,
            }
        },
        nameTextStyle: {
            fontSize: 18,
            fontWeight: 'bold',
        }
    },
    series: [{
        name: 'amplitude',
        type: 'line',
        data: ampData[0]
    }]
};

function mystd(arr) {
    var mean = mymean(arr);
    var tmp = 0;
    for (var i = arr.length - 1; i >= 0; i--) {
        tmp = tmp + (arr[i] - mean) ^ 2;
    };
    return Math.sqrt(tmp);
}

function mymean(arr) {
    var sum = eval(arr.join('+'));
    return sum / arr.length;
}

function queryData() {
    // $.get("query.php?id=" + csi_id,
    $.get("data.json",
        function(data, status) {
            console.log('12223');
            if (data != '0') {
                var obj = JSON.parse(data);
                var amp = obj.amp;
                var didx = obj.didx;
                console.log(didx);
                $(".breathRate").text(didx);
                // PSD refresh
                var freqIndex = obj.freqIndex;
                var psdArray = obj.psdArray;
                detect = obj.detect;
                var freq = obj.freq;
                breathRate = (freq * 60).toFixed(2);
                var maxPSD = Math.max.apply(null, psdArray);

                chart2.setOption({ yAxis: { max: maxPSD + 0.02 }, xAxis: { data: freqIndex }, series: [{ data: psdArray }] });

                csi_id = csi_id + 1;
            };
        });
    //autoScale();
}

function updateChart() {
    //timeIndex.push( timeIndex.shift() + windowLength );
    if (Data_buffer[0].length > 10) {
        for (var i = 0; i < windowNum; i++) {
            ampData[i].push(Data_buffer[i].shift());
            ampData[i].shift()
        }
        chart1.setOption({ series: [{ data: ampData[0] }] });
    };
}

function autoScale() {
    for (var i = 0; i < windowNum; i++) {
        max = Math.max.apply(Math, ampData[i]) + 0.5;
        min = Math.min.apply(Math, ampData[i]) - 0.5;
        eval('chart' + (i + 1)).setOption({ yAxis: { min: min, max: max } });
        $('#scale_dis').text((max - min - 1).toFixed(3).toString());
    }
}

function updateRate() {
    // if (detect == 1) {
    //     $('.breathRate').text(breathRate);
    // } else {
    //     $('.breathRate').text('--');
    // };
    $('.breathRate').text(breathRate);

}

function init() {
    chart1.setOption(option1);
    chart2.setOption(option2);
    //Find latest csi id 
    $.get("query_max.php", function(result) {
        //alert(result);
        csi_id = parseInt(result);
        console.log(csi_id);
        csi_id = 1;
    });
    setInterval('queryData()', 1000);
    setInterval('updateChart()', 45);
    setInterval('autoScale()', 5000);

}

function startupdateRate() {
    setInterval('updateRate()', 2000);
}

init();

