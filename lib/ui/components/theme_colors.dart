import 'package:flutter/material.dart';

class ThemeColors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        Text(
          'White',
          style: textTheme.bodyLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        Text(
          'primary',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.primary,
          ),
        ),
        Text(
          'onPrimary',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
        Text(
          'secondary',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.secondary,
          ),
        ),
        Text(
          'onSecondary',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSecondary,
          ),
        ),
        Text(
          'tertiary',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.tertiary,
          ),
        ),
        Text(
          'onTertiary',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onTertiary,
          ),
        ),
        Text(
          'surface',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.surface,
          ),
        ),
        Text(
          'onSurface',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          'background',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.background,
          ),
        ),
        Text(
          'onBackground',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onBackground,
          ),
        ),
        Text(
          'scrim',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.scrim,
          ),
        ),
        Text(
          'inverseSurface',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.inverseSurface,
          ),
        ),
        Text(
          'onInverseSurface',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onInverseSurface,
          ),
        ),
        Text(
          'inversePrimary',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.inversePrimary,
          ),
        ),
        Text(
          'onPrimaryContainer',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          'onSecondaryContainer',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSecondaryContainer,
          ),
        ),
        Text(
          'onTertiaryContainer',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onTertiaryContainer,
          ),
        ),
        Text(
          'onSurfaceVariant',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
