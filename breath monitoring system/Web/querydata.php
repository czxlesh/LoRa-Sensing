<?php
	#$csi_id = $_GET["id"];
	#echo $csi_id;

	$mysqli = new mysqli("localhost", "root", "", "realtime");
	if ($mysqli->connect_errno) {
		echo "Failed to connect";
	}

	$res = $mysqli->query("SELECT * FROM `breath` WHERE id = (SELECT MAX(id) FROM `breath`) ");


	if ($row = mysqli_fetch_array($res)) {
		echo $row['info'];
	}
	else {
		echo "0";
	}
	
?>
