var svg=d3.select("body")
			.select("#line_area")
			.append("svg")
			.attr("width",500)
			.attr("height",600);
	var total_point=6;

	var xScale = d3.scale.linear()
					.domain([0, total_point-1])
					.range([0, 350]);

	var yScale = d3.scale.linear()
					.domain([0, 10])
					.range([250, 0]);

	var xAxis = d3.svg.axis()
				.scale(xScale)
				.orient("bottom");

	//draw x-Axis
	var x_line=[{x:0 , y:20},{x:total_point,y:20}];
	var lx=d3.svg.line()
				.x(function(d){return xScale(d.x)})
				.y(function(d){return yScale(d.y)})
				.interpolate("step");
	svg.append("path")
		.attr("class","Axis")
		.attr("d",lx(x_line))
		.attr("transform","translate(50,240)");


	var gxAxis = svg.append("g")
					.attr("class","axis")
					.attr("transform","translate(50,490)")//50,490
					.call(xAxis);

	var yAxis = d3.svg.axis()
					.scale(yScale)
					.orient("left");
	//draw y_Axis
	var y_line=[{x:0 , y:20},{x:0,y:25}];
	var ly=d3.svg.line()
				.x(function(d){return xScale(d.x)})
				.y(function(d){return yScale(d.y)})
				.interpolate("step");
	svg.append("path")
		.attr("class","Axis")
		.attr("d",ly(y_line))
		.attr("transform","translate(50,240)");

	var gyAxis = svg.append("g")
					.attr("class","axis")
					.attr("transform","translate(50,240)")//50,240
					.call(yAxis);
	var jsondata=new Array()
	for(var i=0;i<total_point;i++)
	{
		jsondata.push(0);
	}
	var myline=svg.append("path")
				.attr("class","MyPath");
	

	function draw_line(arg1)
	{
			var breath_rate=parseInt(arg1);
    		jsondata.shift();
    		jsondata.push(breath_rate);
			// 2. 线段生成器	
			var line = d3.svg.line()
			.x( function(d,i){ return xScale(i); } )
			.y( function(d){ return yScale(d); } )
			.interpolate("cardinal");
			// 3. 折线图
				myline.attr("d",line(jsondata))
					.attr("transform","translate(50,240)");
	}