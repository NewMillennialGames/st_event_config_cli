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

abstract class StBaseTvRowIfc extends StatelessWidget {
  //
  final TvRowDataContainer assets;

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
    TvRowDataContainer assets, {
    Key? key,
  }) : super(
          assets,
          key: key,
        );

  StateProvider<ActiveGameDetails> get dynStateProv =>
      assets.rowStateProvBuilder(assets.gameKey);

  double get bottomMargin => 0;

  @override
  Widget build(BuildContext context) {
    /*
     assets.item3 is a ActiveGameDetails() entity
     it carries the game-state and toggles
    Trade button on and off

    I'm watching the overridden value
    to force row-rebuild when game-status changes
    */

    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
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
          return IntrinsicHeight(
            child: rowBody(context, agd),
          );
        },
      ),
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
