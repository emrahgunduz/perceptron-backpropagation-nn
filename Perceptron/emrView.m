//
//  emrView.m
//  Perceptron
//
//  Created by Emrah Gunduz.
//  Copyright (c) 2013 Emrah Gunduz. All rights reserved.
//

#import "emrView.h"

@implementation emrView

- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code here.
  }
  
  return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
  if (network) {
    float layerWidth = self.frame.size.width / network.layerCount;
    int maxNodeCount = 0;
    for (int i = 0; i < network.layerCount; i++) {
      NSMutableArray *layer = [network.layers objectAtIndex:i];
      maxNodeCount = MAX((int)layer.count, maxNodeCount);
    }
    
    float nodeRadius = MIN(layerWidth/2, self.frame.size.height / maxNodeCount / 2);
    
    // Draw connection between layers
    for (int i = 0; i < network.layerCount - 1; i++) {
      NSMutableArray *layer = [network.layers objectAtIndex:i];
      NSMutableArray *nextLayer = [network.layers objectAtIndex:i+1];
      
      for (int j = 0; j < layer.count; j++) {
        emrNode *currentNode = [layer objectAtIndex:j];
        float x = i * layerWidth + layerWidth/2;
        float y = (self.frame.size.height / layer.count)/2 + (layer.count > 1 ? (j * self.frame.size.height / layer.count) : 0);
        
        for (int k = 0; k < nextLayer.count; k++) {
          emrConn *conn = [currentNode.connections objectAtIndex:k];
          float xn = (i+1) * layerWidth + layerWidth/2;
          float yn = (self.frame.size.height / nextLayer.count)/2 + (nextLayer.count > 1 ? (k * self.frame.size.height / nextLayer.count) : 0);
          
          [self drawConnectionFromPoint:NSMakePoint(x, y) toPoint:NSMakePoint(xn, yn) withWeight:conn.weight];
        }        
      }
    }
    
    // Draw circles for layer nodes
    for (int i = 0; i < network.layerCount; i++) {
      NSMutableArray *layer = [network.layers objectAtIndex:i];
      
      for (int j = 0; j < layer.count; j++) {
        emrNode *node = [layer objectAtIndex:j];
        float x = i * layerWidth + layerWidth/2 - nodeRadius/2;
        float y = (self.frame.size.height / layer.count)/2 - nodeRadius/2 + (layer.count > 1 ? (j * self.frame.size.height / layer.count) : 0);
        NSRect rect = NSMakeRect(x, y, nodeRadius, nodeRadius);
        [self drawCircleWithRect:rect andOutput:node.output];
      }
    }
  }
}

- (void)drawNetwork:(emrNetwork*)n
{
  network = n;
  [self setNeedsDisplay:YES];
}

- (void)update
{
  [self setNeedsDisplay:YES];
}

- (void)drawCircleWithRect:(NSRect)r andOutput:(double)output
{
  //// Color Declarations
  NSColor* blueFill = [NSColor colorWithCalibratedRed: 0.483 green: 0.643 blue: 0.774 alpha: 1];
  NSColor* shadowBlack = [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 1];
  NSColor* whiteFill = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
  
  //// Shadow Declarations
  NSShadow* shadow = [[NSShadow alloc] init];
  [shadow setShadowColor: shadowBlack];
  [shadow setShadowOffset: NSMakeSize(0.1, 0.1)];
  [shadow setShadowBlurRadius: 5];
  
  //// backCircle Drawing
  NSBezierPath* backCirclePath = [NSBezierPath bezierPathWithOvalInRect: r];
  [blueFill setFill];
  [backCirclePath fill];
  
  ////// backCircle Inner Shadow
  NSRect backCircleBorderRect = NSInsetRect([backCirclePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
  backCircleBorderRect = NSOffsetRect(backCircleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
  backCircleBorderRect = NSInsetRect(NSUnionRect(backCircleBorderRect, [backCirclePath bounds]), -1, -1);
  
  NSBezierPath* backCircleNegativePath = [NSBezierPath bezierPathWithRect: backCircleBorderRect];
  [backCircleNegativePath appendBezierPath: backCirclePath];
  [backCircleNegativePath setWindingRule: NSEvenOddWindingRule];
  
  [NSGraphicsContext saveGraphicsState];
  {
    NSShadow* shadowWithOffset = [shadow copy];
    CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(backCircleBorderRect.size.width);
    CGFloat yOffset = shadowWithOffset.shadowOffset.height;
    shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
    [shadowWithOffset set];
    [[NSColor grayColor] setFill];
    [backCirclePath addClip];
    NSAffineTransform* transform = [NSAffineTransform transform];
    [transform translateXBy: -round(backCircleBorderRect.size.width) yBy: 0];
    [[transform transformBezierPath: backCircleNegativePath] fill];
  }
  [NSGraphicsContext restoreGraphicsState];
  
  NSString* outputTextContent;
  if(output >= 1.0f) {
    outputTextContent = [NSString stringWithFormat:@"%.1f", output];
    output = 1;
  } else {
    outputTextContent = [NSString stringWithFormat:@"%.4f", output];
  }
  
  if(output != output) {
    // NAN
    output = 0;
  }
  
  //// outputCircle Drawing
  NSRect outputCircleRect = NSMakeRect(r.origin.x + 3, r.origin.y + 3, r.size.width - 6, r.size.height - 6);
  NSBezierPath* outputCirclePath = [NSBezierPath bezierPath];
  [outputCirclePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMidX(outputCircleRect), NSMidY(outputCircleRect)) radius: NSWidth(outputCircleRect) / 2 startAngle: 0 endAngle: 360*output clockwise: NO];
  [outputCirclePath lineToPoint: NSMakePoint(NSMidX(outputCircleRect), NSMidY(outputCircleRect))];
  [outputCirclePath closePath];
  
  [NSGraphicsContext saveGraphicsState];  
  [whiteFill setFill];
  [outputCirclePath fill];
  
  //// Color Declarations
  NSColor* textRed = [NSColor colorWithCalibratedRed: 0.886 green: 0 blue: 0 alpha: 1];
  //// outputText Drawing
  NSRect outputTextRect = NSMakeRect(r.origin.x + r.size.width/2 - 50, r.origin.y + 12, 100, r.size.height);
  NSMutableParagraphStyle* outputTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
  [outputTextStyle setAlignment: NSCenterTextAlignment];
  NSDictionary* outputTextFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSFont fontWithName: @"Helvetica-Bold" size: 10], NSFontAttributeName,
                                            textRed, NSForegroundColorAttributeName,
                                            outputTextStyle, NSParagraphStyleAttributeName, nil];
  [outputTextContent drawInRect: NSInsetRect(outputTextRect, 0, 0) withAttributes: outputTextFontAttributes];
  
  [NSGraphicsContext restoreGraphicsState];
  
}

- (void)drawConnectionFromPoint:(NSPoint)a toPoint:(NSPoint)b withWeight:(double)weight
{
  if(weight < 0 ) {
    weight *= -1.0f;
  }
  
  //// Color Declarations
  NSColor* viewFill = [NSColor colorWithCalibratedHue:weight saturation:0.5 brightness:0.75 alpha:0.75];
  
  //// connection Drawing
  NSBezierPath* connectionPath = [NSBezierPath bezierPath];
  [connectionPath moveToPoint: a];
  [connectionPath lineToPoint: b];
  [connectionPath setLineCapStyle: NSRoundLineCapStyle];
  [viewFill setStroke];
  [connectionPath setLineWidth: 2];
  [connectionPath stroke];
}


@end
