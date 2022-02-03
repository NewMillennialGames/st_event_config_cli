part of StUiController;

abstract class StBaseTvRowAbs extends StatelessWidget {
  //
  StdRowData assets;
  StBaseTvRowAbs(this.assets, {Key? key}) : super(key: key);

  Widget rowBody(BuildContext ctx);
}

class StBaseTvRow extends StBaseTvRowAbs {
  //
  StBaseTvRow(
    StdRowData assets, {
    Key? key,
  }) : super(
          assets,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    // throw UnimplementedError('implement in subclass');
    return rowBody(context);
  }

  @override
  Widget rowBody(BuildContext ctx) {
    throw UnimplementedError('implement in subclass');
  }
}
