part of StUiController;

final _gameStatusProvider =
    Provider<ActiveGameDetails>(((ref) => throw UnimplementedError('')));

abstract class StBaseTvRowIfc extends StatelessWidget {
  //
  final TableviewDataRowTuple assets;
  // ActiveGameDetails get gameStatus; // => assets.item3;
  //
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

  // @override
  // ActiveGameDetails get gameStatus => assets.item3;

  @override
  Widget build(BuildContext context) {
    /* 
     assets.item3 is a ActiveGameDetails() entity
     it carries the game-state and toggles
    Trade button on and off

    I'm watching the overridden value
    to force row-rebuild when game-status changes
    */
    return ProviderScope(
      overrides: [
        _gameStatusProvider.overrideWithValue(
          assets.item3,
        ),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          // force rebuild when game status changes
          if (this is RequiresGameStatus) {
            ref.watch(_gameStatusProvider);
          }
          return rowBody(context);
        },
      ),
    );
  }

  @override
  Widget rowBody(BuildContext ctx) {
    // acatual subclass will return the specific row-type
    throw UnimplementedError(
        'implement in subclass  ${'gameStatus.isTradable'}');
  }
}
