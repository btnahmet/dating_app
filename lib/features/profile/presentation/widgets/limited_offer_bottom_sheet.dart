import 'package:dating_app/core/services/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/l10n/app_localizations.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    LoggerService.log('LimitedOfferBottomSheet açıldı');
    return Container(
      height: height * 0.8,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8B0000), Color(0xFF000000)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(width * 0.05),
          topRight: Radius.circular(width * 0.05),
        ),
      ),
      child: Column(
        children: [
          // Header
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n.limitedOffer,
                                                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: width * 0.03,
                             ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n.limitedOfferDescription,
                        textAlign: TextAlign.center,
                                                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                               color: Colors.white70,
                               fontSize: width * 0.018,
                             ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

                    // Bonuses Section
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                                             child: Text(
                         l10n.yourBonuses,
                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: width * 0.025,
                             ),
                       ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        _buildBonusItem(
                            context, Icons.diamond, l10n.premiumAccount),
                        _buildBonusItem(
                            context, Icons.favorite, l10n.moreMatches),
                        _buildBonusItem(
                            context, Icons.trending_up, l10n.highlight),
                        _buildBonusItem(context, Icons.thumb_up, l10n.moreLikes),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: height * 0.04),

                    // Token Packages Section
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                                             child: Text(
                         l10n.selectTokenPackage,
                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: width * 0.025,
                             ),
                       ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        _buildTokenPackage(context, '200', '330', '+10%',
                            '₺99,99', Colors.red, l10n),
                        _buildTokenPackage(context, '2.000', '3.375',
                            '+70%', '₺799,99', Colors.purple, l10n),
                        _buildTokenPackage(context, '1.000', '1.350',
                            '+35%', '₺399,99', Colors.red, l10n),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),
          
          // Call to Action Button
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(width * 0.03),
              child: Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    LoggerService.log('Jetonlar butonuna tıklandı');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                                           child: Text(
                         l10n.seeAllTokens,
                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: width * 0.025,
                           ),
                         textAlign: TextAlign.center,
                       ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusItem(BuildContext context, IconData icon, String title) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.001),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: width * 0.02,
                height: width * 0.02,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.red],
                  ),
                  borderRadius: BorderRadius.circular(width * 0.01),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Icon(icon, color: Colors.white, size: width * 0.006),
              ),
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,   
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.004,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenPackage(BuildContext context, String base, String bonus,
      String percentage, String price, Color color, AppLocalizations l10n) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.001),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(width * 0.008),
        ),
        child: Stack(
          children: [
            Positioned(
              top: width * 0.002,
              right: width * 0.002,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.002, vertical: width * 0.001),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.003),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    percentage,
                    style: TextStyle(
                      color: color,
                      fontSize: width * 0.006,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.004),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          base,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: width * 0.006,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          bonus,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.008,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Jeton',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: width * 0.004,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          price,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.006,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l10n.perWeek,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: width * 0.003,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
