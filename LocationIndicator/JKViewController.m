//
//  JKViewController.m
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

#import "JKViewController.h"

@interface JKViewController()

//Private method for updating the location and rotation of the locaiton indicator, separated from updateLocationIndicator for clarity's sake.
- (void) animateUserArrow;

@end

@implementation JKViewController
@synthesize mapView, locationIndicatorButton, locationIndicatorArrow;

- (void) updateLocationIndicator
{
    //Is the user off-screen?
    if (self.mapView.userLocationVisible == NO) {
        
        //Enable interaction with the component
        locationIndicatorButton.userInteractionEnabled = YES;
        locationIndicatorArrow.userInteractionEnabled = YES;
        
        //Fade in the component if necessary
        if (locationIndicatorButton.alpha != 1) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [locationIndicatorButton setAlpha:1];
            [locationIndicatorArrow setAlpha:1];
            [UIView commitAnimations];
        }
        
        //Update the component's location and rotation
        [self animateUserArrow];
        
    } else {
        
        //Fade out the component if necessary
        if (locationIndicatorButton.alpha != 0) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [locationIndicatorButton setAlpha:0];
            [locationIndicatorArrow setAlpha:0];
            [UIView commitAnimations];
        }
        
        
        //Disable interaction with the component
        locationIndicatorButton.userInteractionEnabled = NO;
        locationIndicatorArrow.userInteractionEnabled = NO;
        
    }
}

- (void) animateUserArrow
{
    //Determine location of user and center of the map in pixels
    CGPoint user;
    user.x = ((self.mapView.userLocation.coordinate.longitude - self.mapView.region.center.longitude) / self.mapView.region.span.longitudeDelta) * self.mapView.frame.size.width;
    user.y = ((self.mapView.userLocation.coordinate.latitude - self.mapView.region.center.latitude) / self.mapView.region.span.latitudeDelta) * self.mapView.frame.size.height;
    
    //Define the bounding box for the button
    CGPoint bounds = CGPointMake(self.mapView.frame.size.width - 35, self.mapView.frame.size.height - 35);
    
    //Assume the center of the map is the origin point at (0,0)
    //Calculate the angle using trig
    float angle = atanf((user.y/user.x));
    float arrowRotation = 0;
    
    
    CGPoint buttonPosition = CGPointMake(0, 0);
    
    //Determine Quadrant
    if (user.y >= 0) {
        //User is located above center of the screen
        
        if (user.x >= 0) {
            //User is located to the right of the center of the screen
            //TOP RIGHT QUANDRANT
            arrowRotation = 1.57079633 - angle;
            //Determine which value we are aware of
            if (angle < 0.785398163) {
                //Less than 45 degrees, we know x and solve for y
                buttonPosition.x = (bounds.x);
                buttonPosition.y = bounds.y - (((bounds.x / 2) * tanf(angle)) + (bounds.y / 2));
            } else {
                //More than 45 degree, we know y and solve for x
                buttonPosition.y = self.mapView.frame.size.height - bounds.y;
                buttonPosition.x = ((bounds.x / 2) + (0.5 * (bounds.y / (tanf(angle)))));
            }
            
        } else if (user.x < 0) {
            //User is located to the left of the center of the screen
            //TOP LEFT QUANDRANT
            arrowRotation = 4.71238898 - angle;
            //Determine which value we are aware of
            if (angle > -0.785398163) {
                //Less than 45 degrees, we know x and solve for y
                buttonPosition.x = self.mapView.frame.size.width - bounds.x;
                buttonPosition.y = (((bounds.x / 2) * tanf(angle)) + (bounds.y / 2));
            } else {
                //More than 45 degree, we know y and solve for x
                buttonPosition.y = self.mapView.frame.size.height - bounds.y;
                buttonPosition.x = ((bounds.x / 2) + (0.5 * (bounds.y / (tanf(angle)))));
            }
        }
        
    } else if (user.y < 0) {
        //User is located below center of the screen
        
        if (user.x >= 0) {
            //User is located to the right of the center of the screen
            //BOTTOM RIGHT QUANDRANT
            arrowRotation = 1.57079633 - angle;
            //Determine which value we are aware of
            if (angle > -0.785398163) {
                //Less than 45 degrees, we know x and solve for y
                buttonPosition.x = (bounds.x);
                buttonPosition.y = bounds.y - (((bounds.x / 2) * tanf(angle)) + (bounds.y / 2));
            } else {
                //More than 45 degree, we know y and solve for x
                buttonPosition.y = bounds.y;
                buttonPosition.x = ((bounds.x / 2) - (0.5 * (bounds.y / (tanf(angle)))));
            }
            
        } else if (user.x < 0) {
            //User is located to the left of the center of the screen
            //BOTTOM LEFT QUANDRANT
            arrowRotation = 4.71238898 - angle;
            //Determine which value we are aware of
            if (angle < 0.785398163) {
                //Less than 45 degrees, we know x and solve for y
                buttonPosition.x = self.mapView.frame.size.width - bounds.x;
                buttonPosition.y = (((bounds.x / 2) * tanf(angle)) + (bounds.y / 2));
            } else {
                //More than 45 degree, we know y and solve for x
                buttonPosition.y = (bounds.y);
                buttonPosition.x = ((bounds.x / 2) - (0.5 * (bounds.y / (tanf(angle)))));
            }
            
        }
    }
    
    //Constrain buttonPosition to bounds
    if (buttonPosition.x > bounds.x) {
        buttonPosition.x = bounds.x;
    } else if (buttonPosition.x < (self.mapView.frame.size.width - bounds.x)) {
        buttonPosition.x = (self.mapView.frame.size.width - bounds.x);
    }
    
    if (buttonPosition.y > bounds.y) {
        buttonPosition.y = bounds.y;
    } else if (buttonPosition.y < (self.mapView.frame.size.height - bounds.y)) {
        buttonPosition.y = (self.mapView.frame.size.height - bounds.y);
    }
    
    //Set button position, while accounting for the height of the top UISearchBar and size of the graphic
    buttonPosition.x = (buttonPosition.x - (locationIndicatorButton.frame.size.width / 2));
    buttonPosition.y = ((buttonPosition.y /*+ topSearch.frame.size.height*/) - (locationIndicatorButton.frame.size.height / 2));
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    locationIndicatorButton.frame = CGRectMake(buttonPosition.x, buttonPosition.y, locationIndicatorButton.frame.size.width, locationIndicatorButton.frame.size.height);
    [UIView commitAnimations];
    
    
    //Rotate and position arrow
    
    CGPoint arrowPosition = CGPointMake(buttonPosition.x, buttonPosition.y);
    arrowPosition.x += locationIndicatorButton.frame.size.width / 2;
    arrowPosition.y += locationIndicatorButton.frame.size.height / 2;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    locationIndicatorArrow.center = CGPointMake(arrowPosition.x, arrowPosition.y);
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation( arrowRotation );
    [locationIndicatorArrow setTransform:rotate];
    
    [UIView commitAnimations];
    
}

- (IBAction) findUserOnMap:(id)sender
{
    
    if (mapView.userLocation.location != nil ) {
        
        //Since this method will display the user's location on-screen, we will pre-emptively fade out the component and disable interaction with it
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [locationIndicatorButton setAlpha:0];
        [locationIndicatorArrow setAlpha:0];
        [UIView commitAnimations];
        
        locationIndicatorButton.userInteractionEnabled = NO;
        locationIndicatorArrow.userInteractionEnabled = NO;
        
        MKCoordinateSpan span = mapView.region.span;
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = mapView.userLocation.location.coordinate;
        
        [self.mapView setRegion:region animated:YES];
        
    } else {
        
        //If the user tapped on the location indicator to access this method, then the user location value should never be nil, but this is here in case this method is called in some other way
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find your location" message:@"No user location could be found, please check your phone settings." delegate:nil cancelButtonTitle:@"Ok." otherButtonTitles: nil];
        [alert show];
        [alert release];
        
    }
}

#pragma mark - Memory Management

- (void) dealloc
{
    self.mapView = nil;
    self.locationIndicatorArrow = nil;
    self.locationIndicatorButton = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Update location indicator
    [self updateLocationIndicator];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // View should be compatible with all interface rotations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation ==UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Map View Delegate Methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self updateLocationIndicator];
}

@end
