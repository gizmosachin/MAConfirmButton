## MAConfirmButton

MAConfirmButton is an animated subclass of UIButton that replicates and improves upon the behavior of the iTunes and App Store "Buy Now" buttons.

![MAConfirmButton](https://raw.githubusercontent.com/gizmosachin/MAConfirmButton/master/MAConfirmButton.png)

## Installation

[CocoaPods](http://cocoapods.org) is the recommended method of installing MAConfirmButton, just add the following line to your `Podfile`:

    pod 'MAConfirmButton', :git => 'https://github.com/gizmosachin/MAConfirmButton'

##Usage

    #import "MAConfirmButton.h"

### Example

	MAConfirmButton *confirmButton = [MAConfirmButton buttonWithTitle:@"Button Title" confirm:@"Confirm Title"];
	[confirmButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];	
	[confirmButton setTintColor:[UIColor blueColor]];
	[confirmButton setAnchor:CGPointMake(270, 25)];	
	[self.view addSubview:confirmButton];

### Init

	+ (MAConfirmButton *)buttonWithTitle:(NSString *)disabledString confirm:(NSString *)confirmString;
	+ (MAConfirmButton *)buttonWithDisabledTitle:(NSString *)disabledString;

### Anchor

It is important that the anchor be set in order to position this button in the view you are adding it to (height\width of the frame are calculated automatically). For now, the anchor point is the **top right** and the button is always aligned right, like the AppStore.

	- (void)setAnchor:(CGPoint)anchor;

### Change State

	- (void)disableWithTitle:(NSString *)disabledString;
