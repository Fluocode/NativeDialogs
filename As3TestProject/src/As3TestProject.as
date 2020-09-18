package
{
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.fluocode.nativeANE.dialogs.NativeAlertDialog;
	import com.fluocode.nativeANE.dialogs.NativeDatePickerDialog;
	import com.fluocode.nativeANE.dialogs.NativeListDialog;
	import com.fluocode.nativeANE.dialogs.NativePickerDialog;
	import com.fluocode.nativeANE.dialogs.support.PickerList;
	import com.fluocode.nativeANE.events.NativeDialogEvent;
	import com.fluocode.nativeANE.events.NativeDialogListEvent;
	

	
	public class As3TestProject extends Sprite
	{
		public function As3TestProject()
		{
			super();
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		
		public function loaderInfo_completeHandler(w):void
		{
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(0xFF794B);
			circle.graphics.drawCircle(150, 150, 30);
			circle.graphics.endFill();
			addChild(circle);
			
			var circle2:Sprite = new Sprite();
			circle2.graphics.beginFill(0x000000);
			circle2.graphics.drawCircle(150, 150, 30);
			circle2.graphics.endFill();
			circle2.x = 200;
			addChild(circle2);
			circle.addEventListener(MouseEvent.CLICK,onPickerButtonClicked);
			circle2.addEventListener(MouseEvent.CLICK,showDatePicker);
		}
		
		protected function onPickerButtonClicked(event:MouseEvent):void
		{
			NativeAlertDialog.showAlert("Jagnięcina","Men",Vector.<String>(["Bekon","Inne"]),trace);
		}
		
		private function onOpen(event):void
		{
			var n:NativePickerDialog = NativePickerDialog(event.target);
			var picker:PickerList = n.dataProvider[1];
			picker.selectedIndex = 3;
		}
		
		
		protected function onCancel(event):void
		{
			trace("onCancel")
			var n:NativeDatePickerDialog = NativeDatePickerDialog(event.target);
			
			n.dispose();
		}
		// THIS IS WHERE THE CRASH HAPPENS. on OK or Cancel
		protected function onCloseDatePicker(event):void
		{
			trace("onCloseDatePicker")
			var n:NativeDatePickerDialog = NativeDatePickerDialog(event.target);
			n.dispose();
		}		
		protected function showDatePicker(e):void
		{
			trace("showDatePicker")
			var d:NativeDatePickerDialog = new NativeDatePickerDialog();
			
			d.addEventListener(NativeDialogEvent.CLOSED,onCloseDatePicker);
			//d.addEventListener(NativeDialogEvent.CANCELED,onCancel);
			//	d.addEventListener(NativeDialogEvent.OPENED,trace);
			d.addEventListener(Event.CHANGE,function(event:Event):void
			{
				
				var n:NativeDatePickerDialog = NativeDatePickerDialog(event.target);
				trace(event);
				trace("Date set to:"+String(n.date));
			});
			d.buttons = Vector.<String>(["Cancel","OK"]);
			d.displayMode = NativeDatePickerDialog.DISPLAY_MODE_DATE;
			d.title = "DatePicker";
			d.message = "Select date:";
			d.show(true);
		}
		
		
		private function readSelectedValuesFromPickerList(event:NativeDialogListEvent):void
		{
			var pickerList:PickerList = PickerList(event.target);
			trace("\n=====00000========000000");
			trace(event);
			trace("selectedIndex: "+pickerList.selectedIndex);
			trace("selectedItem: "+pickerList.selectedItem);
			trace("=====00000========000000\n");
		}
		
		private function readAllSelectedValuesFromPickers(event:NativeDialogEvent):void
		{
			var picker:NativePickerDialog = NativePickerDialog(event.target);
			var v:Vector.<PickerList> = picker.dataProvider;
			var pickerList:PickerList;
			trace("\n=====00000========000000");
			trace(event);
			for (var i:int = 0; i < v.length; i++) 
			{
				pickerList = v[i];
				trace("pickerlist "+i);
				trace("selectedIndex: "+pickerList.selectedIndex);
				trace("selectedItem: "+pickerList.selectedItem);
			}
			trace("=====00000========000000\n");
			
			picker.dispose();
		}
		
		
		private function readSelected(event:NativeDialogEvent):void
		{
			var m:NativeListDialog = NativeListDialog(event.target);
			
			trace(event);
			trace("selectedIndex: "+m.selectedIndex);
			trace("selectedIndexes: "+m.selectedIndexes);
			trace("selectedItem: "+m.selectedItem);
			trace("selectedItems: "+m.selectedItems);
			
			m.dispose();
		}
	}
	
}