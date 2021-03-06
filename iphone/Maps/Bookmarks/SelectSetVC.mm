#import "SelectSetVC.h"
#import "SwiftBridge.h"
#import "UIViewController+Navigation.h"

#include "Framework.h"

@interface SelectSetVC ()
{
  kml::MarkGroupId m_categoryId;
}

@property (copy, nonatomic) NSString * category;
@property (weak, nonatomic) id<MWMSelectSetDelegate> delegate;

@end

@implementation SelectSetVC

- (instancetype)initWithCategory:(NSString *)category
                      categoryId:(kml::MarkGroupId)categoryId
                        delegate:(id<MWMSelectSetDelegate>)delegate
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self)
  {
    _category = category;
    m_categoryId = categoryId;
    _delegate = delegate;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  NSAssert(self.category, @"Category can't be nil!");
  NSAssert(self.delegate, @"Delegate can't be nil!");
  self.title = L(@"bookmark_sets");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // "Add new set" button
  if (section == 0)
    return 1;

  return GetFramework().GetBookmarkManager().GetBmGroupsIdList().size();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  Class cls = [UITableViewCell class];
  auto cell = [tableView dequeueReusableCellWithCellClass:cls indexPath:indexPath];
  if (indexPath.section == 0)
  {
    cell.textLabel.text = L(@"add_new_set");
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  else
  {
    auto & bmManager = GetFramework().GetBookmarkManager();
    auto categoryId = bmManager.GetBmGroupsIdList()[indexPath.row];
    if (bmManager.HasBmCategory(categoryId))
      cell.textLabel.text = @(bmManager.GetCategoryName(categoryId).c_str());

    if (m_categoryId == categoryId)
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
      cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

- (void)moveBookmarkToSetWithCategoryId:(kml::MarkGroupId)categoryId
{
  m_categoryId = categoryId;
  self.category = @(GetFramework().GetBookmarkManager().GetCategoryName(categoryId).c_str());
  [self.tableView reloadData];
  [self.delegate didSelectCategory:self.category withCategoryId:categoryId];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == 0)
  {
    [self.alertController presentCreateBookmarkCategoryAlertWithMaxCharacterNum:60
                                                          minCharacterNum:0
                                                            isNewCategory:YES
                                                                 callback:^BOOL (NSString * name)
     {
       if (![MWMBookmarksManager checkCategoryName:name])
         return false;

       auto const id = [MWMBookmarksManager createCategoryWithName:name];
       [self moveBookmarkToSetWithCategoryId:id];
       return true;
    }];
  }
  else
  {
    auto categoryId = GetFramework().GetBookmarkManager().GetBmGroupsIdList()[indexPath.row];
    [self moveBookmarkToSetWithCategoryId:categoryId];
    [self.delegate didSelectCategory:self.category withCategoryId:categoryId];
    [self backTap];
  }
}

@end
