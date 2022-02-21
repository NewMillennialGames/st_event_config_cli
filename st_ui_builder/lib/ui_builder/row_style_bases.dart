part of StUiController;

abstract class StBaseTvRowIfc extends StatelessWidget {
  //
  final TableviewDataRowTuple assets;
  const StBaseTvRowIfc(
    this.assets, {
    Key? key,
  }) : super(key: key);

  Widget rowBody(BuildContext ctx);
}

class StBaseTvRow extends StBaseTvRowIfc {
  // base class for EVERY tableview row
  // on 4 main screens of scoretrader
  const StBaseTvRow(
    TableviewDataRowTuple assets, {
    Key? key,
  }) : super(
          assets,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    // you can wrap row body here if needed
    // should also use ScopedProvider here to toggle
    // Trade button on and off
    return rowBody(context);
  }

  @override
  Widget rowBody(BuildContext ctx) {
    // acatual subclass will return the specific row-type
    throw UnimplementedError('implement in subclass');
  }
}
