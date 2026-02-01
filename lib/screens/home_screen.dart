import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../logic/calculator_engine.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _forceController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load profiles when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      appState.loadProfiles();
      _forceController.text = appState.force.toString();
      _lengthController.text = appState.length.toString();
    });
  }

  @override
  void dispose() {
    _forceController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final l10n = appState.locale.strings;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.get('app_title')),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // Language toggle button
              TextButton.icon(
                onPressed: () => appState.toggleLocale(),
                icon: const Icon(Icons.language),
                label: Text(appState.locale == AppLocale.en ? 'DE' : 'EN'),
              ),
            ],
          ),
          body: appState.isLoading
              ? Center(child: CircularProgressIndicator())
              : appState.errorMessage != null
                  ? Center(child: Text(appState.errorMessage!))
                  : _buildContent(context, appState, l10n),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AppState appState, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Load Type Toggle
          _buildLoadTypeToggle(appState, l10n),
          const SizedBox(height: 16),
          
          // Support Type Selection
          _buildSupportTypeSelector(appState, l10n),
          const SizedBox(height: 16),
          
          // Input Fields
          _buildInputFields(appState, l10n),
          const SizedBox(height: 16),
          
          // Profile Selector
          _buildProfileSelector(context, appState, l10n),
          const SizedBox(height: 16),
          
          // Axis Toggle
          _buildAxisToggle(appState, l10n),
          const SizedBox(height: 24),
          
          // Result Display
          _buildResultDisplay(appState, l10n),
        ],
      ),
    );
  }

  Widget _buildLoadTypeToggle(AppState appState, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.get('load_type'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SegmentedButton<LoadType>(
              segments: [
                ButtonSegment<LoadType>(
                  value: LoadType.pointLoad,
                  label: Text(l10n.get('point_load')),
                  icon: const Icon(Icons.adjust),
                ),
                ButtonSegment<LoadType>(
                  value: LoadType.distributedLoad,
                  label: Text(l10n.get('distributed_load')),
                  icon: const Icon(Icons.linear_scale),
                ),
              ],
              selected: {appState.loadType},
              onSelectionChanged: (Set<LoadType> selection) {
                appState.setLoadType(selection.first);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTypeSelector(AppState appState, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.get('support_type'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSupportTypeCard(
                  appState,
                  SupportType.simpleBeam,
                  Icons.horizontal_rule,
                  l10n.get('simple_beam'),
                  l10n.get('simple_beam_desc'),
                ),
                _buildSupportTypeCard(
                  appState,
                  SupportType.cantilever,
                  Icons.turn_right,
                  l10n.get('cantilever'),
                  l10n.get('cantilever_desc'),
                ),
                _buildSupportTypeCard(
                  appState,
                  SupportType.fixedFixed,
                  Icons.expand,
                  l10n.get('fixed_fixed'),
                  l10n.get('fixed_fixed_desc'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTypeCard(
    AppState appState,
    SupportType type,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = appState.supportType == type;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => appState.setSupportType(type),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).colorScheme.primaryContainer 
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Theme.of(context).colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputFields(AppState appState, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _forceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: '${l10n.get('force')} (${l10n.get('force_unit')})',
                hintText: l10n.get('enter_force'),
                prefixIcon: const Icon(Icons.fitness_center),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                final parsed = double.tryParse(value);
                if (parsed != null) {
                  appState.setForce(parsed);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lengthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: '${l10n.get('length')} (${l10n.get('length_unit')})',
                hintText: l10n.get('enter_length'),
                prefixIcon: const Icon(Icons.straighten),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                final parsed = double.tryParse(value);
                if (parsed != null) {
                  appState.setLength(parsed);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSelector(BuildContext context, AppState appState, AppLocalizations l10n) {
    final profile = appState.selectedProfile;
    
    return Card(
      child: InkWell(
        onTap: () => _showProfileBottomSheet(context, appState, l10n),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Profile Image Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.view_in_ar,
                  size: 32,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.name ?? l10n.get('no_profile'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (profile != null) ...[
                      Text(
                        profile.category,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Ix: ${profile.ixCm4} cm⁴ | Iy: ${profile.iyCm4} cm⁴',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAxisToggle(AppState appState, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              l10n.get('axis'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment<bool>(
                  value: true,
                  label: Text(l10n.get('x_axis')),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text(l10n.get('y_axis')),
                ),
              ],
              selected: {appState.useXAxis},
              onSelectionChanged: (Set<bool> selection) {
                appState.setUseXAxis(selection.first);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultDisplay(AppState appState, AppLocalizations l10n) {
    final deflection = appState.deflectionResult;
    
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              l10n.get('maximum_deflection'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '${deflection.toStringAsFixed(4)} mm',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.get('deflection'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileBottomSheet(BuildContext context, AppState appState, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.get('select_profile'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Profile List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: appState.profiles.length,
                    itemBuilder: (context, index) {
                      final profile = appState.profiles[index];
                      final isSelected = appState.selectedProfile?.id == profile.id;
                      
                      return ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.view_in_ar,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                        title: Text(profile.name),
                        subtitle: Text(
                          'Ix: ${profile.ixCm4} cm⁴ | Iy: ${profile.iyCm4} cm⁴',
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          appState.selectProfileModel(profile);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
