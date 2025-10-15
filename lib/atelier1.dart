import 'package:flutter/material.dart';

class ProfilePageM3 extends StatelessWidget {
  const ProfilePageM3({super.key});

  // Fonction helper pour les statistiques
  Widget _buildStatChip(String value, String label, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Étape 1: Photo avec badge
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage: const AssetImage('images/person1.png'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.check,
                    color: colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Étape 2: Nom et titre
            Text(
              'Mohamed Tounsi',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Développeur Flutter',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // Étape 3: Statistiques
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildStatChip('128', 'Abonnés', colorScheme),
                _buildStatChip('56', 'Projets', colorScheme),
                _buildStatChip('2 ans', 'Expérience', colorScheme),
              ],
            ),
            const SizedBox(height: 32),

            // Étape 4: Section À propos
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'À propos',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Passionné par le développement mobile et les technologies innovantes. '
                      'J\'aime créer des applications qui améliorent la vie des utilisateurs.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Étape 5: Bouton flottant
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action de modification
          debugPrint('Modification du profil');
        },
        icon: const Icon(Icons.edit),
        label: const Text('Modifier le profil'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
