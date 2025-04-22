library parent;

List<String> bleData = [];
//added
Function? onBleDataChanged;

void setBleData(List<String> data) {
  bleData = data;
  if (onBleDataChanged != null) {
    onBleDataChanged!();
  }
}
//ValueNotifier<List<String>> bleData = ValueNotifier<List<String>>([]);
