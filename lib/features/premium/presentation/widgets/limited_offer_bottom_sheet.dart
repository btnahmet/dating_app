import 'package:flutter/material.dart';
import 'package:dating_app/l10n/app_localizations.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF8B0000), Color(0xFF000000)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  l10n.limitedOffer,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.limitedOfferDescription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ),
          
          // Bonuses Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.yourBonuses,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildBonusItem(context, Icons.diamond, l10n.premiumAccount)),
                    Expanded(child: _buildBonusItem(context, Icons.favorite, l10n.moreMatches)),
                    Expanded(child: _buildBonusItem(context, Icons.trending_up, l10n.highlight)),
                    Expanded(child: _buildBonusItem(context, Icons.thumb_up, l10n.moreLikes)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Token Packages Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectTokenPackage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTokenPackage(context, '200', '330', '+10%', '₺99,99', Colors.red, l10n)),
                    Expanded(child: _buildTokenPackage(context, '2.000', '3.375', '+70%', '₺799,99', Colors.purple, l10n)),
                    Expanded(child: _buildTokenPackage(context, '1.000', '1.350', '+35%', '₺399,99', Colors.red, l10n)),
                  ],
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Call to Action Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement token purchase
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  l10n.seeAllTokens,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
    final height = MediaQuery.of(context).size.height;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.005),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width * 0.1,
            height: width * 0.1,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.pink, Colors.red],
              ),
              borderRadius: BorderRadius.circular(width * 0.04),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: Icon(icon, color: Colors.white, size: width * 0.04),
          ),
          SizedBox(height: height * 0.005),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: width * 0.03,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenPackage(BuildContext context, String base, String bonus, String percentage, String price, Color color, AppLocalizations l10n) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.005),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(width * 0.02),
      ),
      child: Stack(
        children: [
          // Percentage Badge
          Positioned(
            top: width * 0.02,
            right: width * 0.01,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.002),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(width * 0.015),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  percentage,
                  style: TextStyle(
                    color: color,
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      base,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width * 0.04,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      bonus,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.token,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width * 0.025,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      price,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.perWeek,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: width * 0.02,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 