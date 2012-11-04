//
//  JKViewController.h
//  LocationIndicator
//
//  Created by Joel Koroniak on 12-01-15.
//  Copyright (c) 2012 Joel Koroniak. All rights reserved.
//
//  http://www.craftmobile.ca/
//
//  Special Thanks to Sean McIntyre - http://xverba.ca/ for the graphical assets, and assistance with the math involved.
//
//  Redistribution and use of any significant portion of this code, in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of any significant portion of source code must include
//  a comment crediting its author and www.craftmobile.ca
//
//  * Redistributions in source or binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of the author nor the names of its contributors may be used
//  to endorse or promote products derived from this software without specific
//  prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface JKViewController : UIViewController {
    
    /**
     Reference to the button used to center map on the user's location.
     */
    IBOutlet UIButton *locationIndicatorButton;
    
    /**
     Reference to the UIImageView which contains the arrow portion of the user location indicator.
     */
    IBOutlet UIImageView *locationIndicatorArrow;
    
}

///----------------------------------------------------------------------------------------
/// @name Updating the User Location Indicator
///----------------------------------------------------------------------------------------

/** Enables, displays, and updates the location indicator if the user's location is off-screen when called
 
This method checks if the user's current location is off-screen and if it is, it enables the location indicator, fades in the graphic, and updates the indicator's location and rotation. If the user's location is on-screen it fades the component out (if it has not already been faded out) and disables any user interaction with the component.
 
 */
- (void) updateLocationIndicator;

/** Centers map on the user's location while maintaining the current span value for the map view.
 
 This method hides and disables the location indicator and centers the map view on the user's current location value while maintaining the current span value for the map view. If no current location value is available, it warns the user with a dialogue box.
 
 @param sender The object calling this method.
 */
- (IBAction) findUserOnMap:(id)sender;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *locationIndicatorButton;
@property (nonatomic, retain) IBOutlet UIImageView *locationIndicatorArrow;
@end
