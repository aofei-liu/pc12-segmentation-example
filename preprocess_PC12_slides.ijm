bf = 0;
nuc = 1; //nucleus channel
fluo_green = 2; 
fluo_red = 3;
fluo_farred = 4;
labels = newArray("old_led_dark", "old_led_light", "mouse_led_dark", "mouse_led_light");

run("Bio-Formats Macro Extensions");
currentDirectory = getDirectory("Choose a directory");

fileList = getFileList(currentDirectory);
ct = 0;

for (file = 0; file < fileList.length; file++) {
		
	Ext.isThisType(currentDirectory + fileList[file], supportedFileFormat);
	if (supportedFileFormat=="true") {
		label = labels[ct];
		ct += 1 ;
		Ext.setId(currentDirectory + fileList[file]);
		Ext.getSeriesCount(seriesCount);


	for (j = 1; j <= seriesCount; j++){
		run("Close All");
		run("Bio-Formats Importer", "open=["+currentDirectory + fileList[file]+"] autoscale color_mode=Default split_channels view=[Standard ImageJ] stack_order=Default series_"+j+"");
		name = getTitle();
		//print(name);
		prefix = substring (name, 0, lastIndexOf(name," "));
		//print(prefix);
	
	bf_name = prefix+" C="+d2s(bf, 0);
	green_name = prefix+" C="+d2s(fluo_green, 0);
	nuc_name = prefix+" C="+d2s(nuc, 0);
	red_name = prefix+" C="+d2s(fluo_red, 0);
	farred_name = prefix+" C="+d2s(fluo_farred, 0);
	
	selectWindow(green_name);
	rename("pErk");	
	
	selectWindow(red_name);
	rename("mRuby3");
	
	selectWindow(nuc_name);
	rename("Hoechst");
	
	selectWindow(bf_name);
	rename("Brightfield");
	
	selectWindow(farred_name);
	rename("tdnano647");
	
	
	run("Merge Channels...", "c1=mRuby3 c2=pErk c3=Hoechst create keep");
	saveAs("tif", currentDirectory+"merged_Ruby\\"+label+String.pad(j,2)+".tif");
	close();
	
	selectWindow("tdnano647");
	saveAs("tif", currentDirectory+"Brightfield\\"+label+String.pad(j,2)+".tif");
	close();
	
	selectWindow("Brightfield");
	saveAs("tif", currentDirectory+"Brightfield\\"+label+String.pad(j,2)+".tif");
	close();
		
		}
	}
	else{
		continue;
	}
}
