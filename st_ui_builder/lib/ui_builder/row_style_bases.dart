part of StUiController;

const kRowBorder = Border.symmetric(
  horizontal: BorderSide(
    color: StColors.lightGray,
    width: UiSizes.rowBorderWidth,
  ),
);

const kRowBoxDecor = BoxDecoration(
  color: StColors.black,
  border: kRowBorder,
);

// final _gameStatusProvider = Provider<ActiveGameDetails>(
//   ((ref) => throw UnimplementedError('')),
// );

abstract class StBaseTvRowIfc extends StatelessWidget {
  //
  final TableviewDataRowTuple assets;
  // ActiveGameDetails get gameStatus; // => assets.item3;
  //
  const StBaseTvRowIfc(
    this.assets, {
    Key? key,
  }) : super(key: key);

  Widget rowBody(BuildContext ctx, ActiveGameDetails agd, WidgetRef ref);
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

  StateProvider<ActiveGameDetails> get dynStateProv =>
      assets.item4(assets.item3);

  @override
  Widget build(BuildContext context) {
    /*
     assets.item3 is a ActiveGameDetails() entity
     it carries the game-state and toggles
    Trade button on and off

    I'm watching the overridden value
    to force row-rebuild when game-status changes
    */
    double rowHeight =
        this is ShowsTwoAssets ? UiSizes.dblRowHeight : UiSizes.singleRowHeight;

    return Container(
      height: rowHeight,
      padding: const EdgeInsets.all(2),
      decoration: kRowBoxDecor,
      child: Consumer(
        builder: (context, ref, child) {
          // force rebuild when key state changes
          Event? ev = ref.watch(currEventProvider);
          ActiveGameDetails agd = ref.watch(dynStateProv);
          print(
            'StBaseTvRow is rebuilding for ${agd.competitionKey} in event ${ev?.title ?? '_missing'}',
          );
          // if (this is RequiresGameStatus) {
          //   agd = ref.watch(dynStateProv);
          // } else {
          //   agd = ref.read(dynStateProv);
          // }
          // force rebuild when asset price changes
          // if (this is RequiresPriceChangeProps) {
          //   // ref.watch(_somePriceProvider);
          // }
          return rowBody(context, agd, ref);
        },
      ),
    );
  }

  @override
  Widget rowBody(BuildContext ctx, ActiveGameDetails agd, WidgetRef ref) { 
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