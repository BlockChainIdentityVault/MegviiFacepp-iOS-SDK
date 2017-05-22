//
//  MGFaceContrast.m
//  FaceppDemo
//
//  Created by Li Bo on 2017/5/19.
//  Copyright © 2017年 megvii. All rights reserved.
//

#import "MGFaceContrast.h"
#import "MGFaceContrastCell.h"
#import "MGFileManager.h"

@interface MGFaceContrast () <UITableViewDelegate, UITableViewDataSource, MGFaceContrastCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation MGFaceContrast

+ (instancetype)storyboardInstance{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MGFaceContrast" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:@"MGFaceContrast"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bottomView.backgroundColor = [UIColor colorWithRed:41/255. green:135/255. blue:192/255. alpha:1];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate - 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MGFaceContrastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = _models[indexPath.row];
    cell.delegate = self;
    return cell;
}


#pragma amrk - MGFaceContrastCellDelegate -

- (void)nameDidEdit:(MGFaceContrastModel *)model{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入用户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *name = alert.textFields.firstObject;
        NSString *str = name.text;
        if (str.length > 0) {
            model.name = str;
            [self.tableView reloadData];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)modelDidSelected:(MGFaceContrastModel *)model{
    NSLog(@"");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelBtnAction:(UIButton *)sender {
    for (MGFaceContrastModel *model in _models) {
        model.selected = NO;
    }
    [self.tableView reloadData];
}

- (IBAction)okBtnAction:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray array];
    for (MGFaceContrastModel *model in _models) {
        if (model.selected == YES) {
            [arr addObject:model];
        }
    }
    [MGFileManager saveModels:arr];
}

@end
