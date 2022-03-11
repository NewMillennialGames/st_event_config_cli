part of StUiController;

final _gameStatusProvider = Provider<ActiveGameDetails>(
  ((ref) => throw UnimplementedError('')),
);

abstract class StBaseTvRowIfc extends StatelessWidget {
  //
  final TableviewDataRowTuple assets;
  // ActiveGameDetails get gameStatus; // => assets.item3;
  //
  const StBaseTvRowIfc(
    this.assets, {
    Key? key,
  }) : super(key: key);

  Widget rowBody(BuildContext ctx, ActiveGameDetails agd);
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
    return Consumer(
      builder: (context, ref, child) {
        // force rebuild when game status changes
        ActiveGameDetails agd;
        if (this is RequiresGameStatus) {
          agd = ref.watch(assets.item3);
        } else {
          agd = ref.read(assets.item3);
        }
        // force rebuild when asset price changes
        // if (this is RequiresPriceChangeProps) {
        //   // ref.watch(_somePriceProvider);
        // }
        return rowBody(context, agd);
      },
      // ),
    );
  }

  @override
  Widget rowBody(BuildContext ctx, ActiveGameDetails agd) {
    throw UnimplementedError(
      'acatual subclass should return the specific row-type; implement there',
    );
  }
}


    // return ProviderScope(
    //   overrides: [
    //     _gameStatusProvider.overrideWithValue(
    //       assets.item3,
    //     ),
    //   ],
    //   child: