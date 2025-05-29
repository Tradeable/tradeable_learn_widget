class TutorialManager {
  static final Map<String, List<Map<String, dynamic>>> _tutorials = {
    'delivery_tutorial': [
      {
        'prompt':
            'Let\'s understand Delivery - or Cash & Carry Order Type. Select DELIVERY from the options below.',
        'enabledElements': ['product_DELIVERY'],
        'checkType': 'productSelection',
        'expectedValue': 'DELIVERY',
      },
      {
        'prompt':
            'Great! Now set the quantity to 5. Notice the margin requirement below that calculates (quantity × price).',
        'enabledElements': ['quantity_controls'],
        'checkType': 'quantitySelection',
        'expectedValue': 5,
      },
      {
        'prompt':
            'Perfect! Now choose between MARKET or LIMIT order type. Toggle between them to see the explanation of each order type.',
        'enabledElements': ['price_type_MARKET', 'price_type_LIMIT'],
        'checkType': 'priceTypeSelection',
        'expectedValue': ['MARKET', 'LIMIT'],
      },
      {
        'prompt':
            'Excellent! Now toggle to the Advanced Section to explore validity options (DAY, IOC & GTD). Click on "Advanced Options" below.',
        'enabledElements': ['advanced_toggle'],
        'checkType': 'advancedToggle',
        'expectedValue': true,
      },
      {
        'prompt':
            'Great! Now you can see the validity options. Toggle through DAY, IOC & GTD to understand each validity type and their descriptions.',
        'enabledElements': ['validity_DAY', 'validity_IOC', 'validity_GTD'],
        'checkType': 'validitySelection',
        'expectedValue': ['DAY', 'IOC', 'GTD'],
      },
      {
        'prompt':
            'Perfect! You\'ve completed the Delivery tutorial. Click BUY to finish.',
        'enabledElements': ['buy_button'],
        'checkType': 'buyButtonPressed',
        'expectedValue': true,
      },
    ],
    'intraday_tutorial': [
      {
        'prompt':
            'Let\'s understand Intraday trading. Select INTRADAY from the options below.',
        'enabledElements': ['product_INTRADAY'],
        'checkType': 'productSelection',
        'expectedValue': 'INTRADAY',
      },
      {
        'prompt':
            'Excellent! Now set the quantity to 10. Notice the reduced margin requirement compared to delivery orders.',
        'enabledElements': ['quantity_controls'],
        'checkType': 'quantitySelection',
        'expectedValue': 10,
      },
      {
        'prompt':
            'Great! Now choose between MARKET or LIMIT order type. Toggle between them to understand the difference - Market orders execute immediately while Limit orders execute at your specified price.',
        'enabledElements': ['price_type_MARKET', 'price_type_LIMIT'],
        'checkType': 'priceTypeSelection',
        'expectedValue': ['MARKET', 'LIMIT'],
      },
      {
        'prompt':
            'Perfect! Now toggle to the Advanced Section to explore validity options. Click on "Advanced Options" to see DAY, IOC & GTD options.',
        'enabledElements': ['advanced_toggle'],
        'checkType': 'advancedToggle',
        'expectedValue': true,
      },
      {
        'prompt':
            'Excellent! Toggle through the validity options to understand each: DAY (valid for current trading day), IOC (immediate or cancel), and GTD (good till date).',
        'enabledElements': ['validity_DAY', 'validity_IOC', 'validity_GTD'],
        'checkType': 'validitySelection',
        'expectedValue': ['DAY', 'IOC', 'GTD'],
      },
      {
        'prompt':
            'Outstanding! You\'ve mastered Intraday trading. Click BUY to complete your intraday order.',
        'enabledElements': ['buy_button'],
        'checkType': 'buyButtonPressed',
        'expectedValue': true,
      },
    ],
    'cover_tutorial': [
      {
        'prompt':
            'Let\'s understand COVER orders. Select COVER from the options below.',
        'enabledElements': ['product_COVER'],
        'checkType': 'productSelection',
        'expectedValue': 'COVER',
      },
      {
        'prompt':
            'Perfect! Now set the quantity to 8. Notice the margin requirement calculation for cover orders.',
        'enabledElements': ['quantity_controls'],
        'checkType': 'quantitySelection',
        'expectedValue': 8,
      },
      // {
      //   'prompt':
      //       'Great! Choose between MARKET or LIMIT order type. Toggle between them to see their explanations - this determines how your order will be executed.',
      //   'enabledElements': ['price_type_MARKET', 'price_type_LIMIT'],
      //   'checkType': 'priceTypeSelection',
      //   'expectedValue': ['MARKET', 'LIMIT'],
      // },
      {
        'prompt':
            'Excellent! Now you\'ll see the Stop Loss field (auto-filled at -10% of current price). Set it three points higher.',
        'enabledElements': ['stop_loss_controls'],
        'checkType': 'set_stop_loss',
        'expectedValue': 413.03,
      },
      {
        'prompt':
            'Perfect! Below you\'ll see the Target Price field (auto-filled at +10% of current price). Set it three points lower.',
        'enabledElements': ['target_price_controls'],
        'checkType': 'set_target_price',
        'expectedValue': 498.15,
      },
      // {
      //   'prompt':
      //       'Great! Now toggle to the Advanced Section to explore validity options (DAY, IOC & GTD). Click on "Advanced Options".',
      //   'enabledElements': ['advanced_toggle'],
      //   'checkType': 'advancedToggle',
      //   'expectedValue': true,
      // },
      // {
      //   'prompt':
      //       'Excellent! Toggle through each validity option to understand: DAY (current trading day only), IOC (immediate execution or cancel), GTD (good till specified date).',
      //   'enabledElements': ['validity_DAY', 'validity_IOC', 'validity_GTD'],
      //   'checkType': 'validitySelection',
      //   'expectedValue': ['DAY', 'IOC', 'GTD'],
      // },
      {
        'prompt':
            'Outstanding! You\'ve completed the Cover order tutorial. Click BUY to place your cover order with built-in risk management.',
        'enabledElements': ['buy_button', 'advanced_toggle'],
        'checkType': 'buyButtonPressed',
        'expectedValue': true,
      },
    ],
  };

  static List<Map<String, dynamic>>? getTutorial(String tutorialId) {
    return _tutorials[tutorialId];
  }

  static List<Map<String, dynamic>>? getTutorialByType(
      TutorialType tutorialType) {
    return _tutorials[tutorialType.id];
  }
}

enum TutorialType {
  deliveryTutorial('delivery_tutorial'),
  intradayTutorial('intraday_tutorial'),
  coverTutorial('cover_tutorial');

  const TutorialType(this.id);
  final String id;

  static TutorialType? fromString(String? id) {
    if (id == null) return null;
    for (TutorialType type in TutorialType.values) {
      if (type.id == id) return type;
    }
    return null;
  }
}
