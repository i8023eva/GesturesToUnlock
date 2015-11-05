//
//  EVALockView.m
//  GesturesToUnlock
//
//  Created by lyh on 15/11/5.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import "EVALockView.h"

@implementation EVALockView


#pragma mark - 圆的选中
// 获取触摸点
- (CGPoint)pointWithTouches:(NSSet *)touches
{
    // 当前触摸点
    UITouch *touch = [touches anyObject];
    return  [touch locationInView:self];
}
// 获取触摸按钮
- (UIButton *)buttonWithPoint:(CGPoint)point
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)){ // 判断点在按钮上   ---前提是处于同一个坐标系
            return btn;
        }
    }
    return nil;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 当前触摸点
    CGPoint pos = [self pointWithTouches:touches];
    // 获取触摸按钮
    UIButton *btn = [self buttonWithPoint:pos];
    if (btn) { // 有触摸按钮的时候才需要选中
        btn.selected = YES;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 当前触摸点
    CGPoint pos = [self pointWithTouches:touches];
    // 获取触摸按钮
    UIButton *btn = [self buttonWithPoint:pos];
    if (btn) { // 有触摸按钮的时候才需要选中
        btn.selected = YES;
    }
}
#pragma mark - 布局
-(void)layoutSubviews {
    [super layoutSubviews];
    
    int column = 0;
    int row = 0;
    
    CGFloat btnW = 74.f;
    CGFloat btnH = 74.f;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    
    int totalColumn = 3;
    CGFloat margin = (self.bounds.size.width - totalColumn * btnW) / (totalColumn + 1);
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *button = self.subviews[i];
        
        column = i % 3;
        row = i / 3;
        btnX = margin + (margin + btnW) * column;
        btnY = (margin + btnH) * row;
        
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

-(void) setupSubView {
    for (int i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        //取消系统自带的高亮状态   ---变灰
        button.userInteractionEnabled = NO;
        
        [self addSubview:button];
    }
}

//解析 xib 时调用
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubView];
    }
    return self;
}
//加载 xib 完毕时调用
-(void)awakeFromNib {
    [super awakeFromNib];
}

@end
