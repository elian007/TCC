# TCC

 1. Run the **loadDatas** script.
 	
	That will import the data from your *Dataset* and generate the table 
	named **tableDatas**.

	For change your dataset, modify the following line in **loadDatas** script.

	```
	filename = 'yourDatasetName.csv'; 
	```
	The variable *endRow* defines how many rows will be imported from the dataset, if you want to
	import only a part, change to something like.

	*i.e. To get one thousand lines*
	```
	endRow = 1000;
	```

 2. Run the **calculateTimeInterval(interval, table)** function.

	This function receives two input parameters, the first is sample size, in this format **'hh:mm:ss'** .
	The second parameter is a table *(has to be a type table)*, where data will be fetched based on the sample size passed.

	*i.e. To get one minute intervals*
	```
	calculateTimeInterval('00:01:00', tableDatas) 
	```
