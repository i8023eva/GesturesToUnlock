//
//  EVALockView.m
//  GesturesToUnlock
//
//  Created by lyh on 15/11/5.
//  Copyright © 2015年 lyh. All rights reserved.
//

#import "EVALockView.h"

@interface EVALockView ()
//存储划过的 button
@property (nonatomic, strong) NSMutableArray *btnArray;
//最后一次连线的位置
@property (nonatomic, assign) CGPoint moveP;
@end

@implementation EVALockView

-(NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

#pragma mark - 划线  setNeedsDisplay
-(void)drawRect:(CGRect)rect {
    if (self.btnArray.count == 0) return;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //BUtton 之间的连线
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = self.btnArray[idx];
        if (idx == 0) {
            [path moveToPoint:button.center];
        }else {
            [path addLineToPoint:button.center];
        }
    }];
    //连完最后一个 button de 线
    [path addLineToPoint:self.moveP];
    
    [[UIColor colorWithRed:0.502 green:1.000 blue:0.000 alpha:1.000] set];
    path.lineWidth = 8.f;
    path.lineJoinStyle = kCGLineJoinRound;
    
    [path stroke];
}

#pragma mark - 取消选中
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *string = [NSMutableString string];
    for (UIButton *btn in self.btnArray) {
        [string appendFormat:@"%ld----", btn.tag];
    }
    NSLog(@"%@", string);//打印路径---沙盒
    
//    [self.btnArray makeObjectsPerformSelector:@selector(setSelected:)  withObject:@(NO)];    不好使了
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setValue:@(NO) forKeyPath:@"selected"];
    }];
    
    
    [self.btnArray removeAllObjects];
    [self setNeedsDisplay];
}

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
        CGFloat centerWidth = 24;//圆心附近
        CGPoint center = btn.center;
        CGFloat x = center.x - centerWidth * 0.5;
        CGFloat y = center.y - centerWidth * 0.5;
        
        CGRect frame = CGRectMake(x, y, centerWidth, centerWidth);
        if (CGRectContainsPoint(frame, point)){ // 判断点在按钮上   ---前提是处于同一个坐标系
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
    if (btn && !btn.isSelected) { // 有触摸按钮的时候才需要选中    --- 不能重复选中
        btn.selected = YES;
        [self.btnArray addObject:btn];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 当前触摸点
    CGPoint pos = [self pointWithTouches:touches];
    //
    self.moveP = pos;
    
    // 获取触摸按钮
    UIButton *btn = [self buttonWithPoint:pos];
    if (btn && !btn.isSelected) { // 有触摸按钮的时候才需要选中
        btn.selected = YES;
        [self.btnArray addObject:btn];
    }
    //重绘
    [self setNeedsDisplay];
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
        button.tag = i + 9000;
        
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
