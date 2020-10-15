#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/regmap.h>
#include <linux/of.h>
#include "custom_functions.h"
static struct class *cl;
static dev_t dev_num;
/* Device struct */
struct fe_simple_gain_dev {
  struct cdev cdev;
  void __iomem *regs;
  char *name;
  unsigned int Gain;
  unsigned int Enable;
};

static int simple_gain_init(void);
static void simple_gain_exit(void);
static int simple_gain_probe(struct platform_device *pdev);
static int simple_gain_remove(struct platform_device *pdev);
static ssize_t simple_gain_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t simple_gain_write(struct file *file, const char *buffer, size_t len, loff_t *offset);
static int simple_gain_open(struct inode *inode, struct file *file);
static int simple_gain_release(struct inode *inode, struct file *file);

static ssize_t name_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t Gain_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t Gain_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t Enable_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t Enable_read  (struct device *dev, struct device_attribute *attr, char *buf);
typedef struct fe_simple_gain_dev fe_simple_gain_dev_t;
/* ID Matching struct */
static struct of_device_id fe_simple_gain_dt_ids[] = {
  {
    .compatible = "dev,al-simple_gain"
  },
  { }
};

/* Platform driver struct */
static struct platform_driver simple_gain_platform = {
  .probe = simple_gain_probe,
  .remove = simple_gain_remove,
  .driver = {
    .name = "Flat Earth simple_gain Driver",
    .owner = THIS_MODULE,
    .of_match_table = fe_simple_gain_dt_ids
  }
};

/* File ops struct */
static const struct file_operations fe_simple_gain_fops = {
  .owner = THIS_MODULE,
  .read = simple_gain_read,
  .write = simple_gain_write,
  .open = simple_gain_open,
  .release = simple_gain_release,
};


MODULE_LICENSE("GPL");
MODULE_AUTHOR("Autogen <support@flatearthinc.com");
MODULE_DESCRIPTION("Loadable kernel module for the simple_gain");
MODULE_VERSION("1.0");
MODULE_DEVICE_TABLE(of, fe_simple_gain_dt_ids);
module_init(simple_gain_init);
module_exit(simple_gain_exit);

DEVICE_ATTR(name, 0444, name_read, NULL);
DEVICE_ATTR(Gain, 0664, Gain_read, Gain_write);
DEVICE_ATTR(Enable, 0664, Enable_read, Enable_write);
static struct attribute *simple_gain_attrs[] = {  &dev_attr_name.attr,  &dev_attr_Gain.attr,  &dev_attr_Enable.attr,  NULL};

ATTRIBUTE_GROUPS(simple_gain);

static int simple_gain_init(void) {
  int ret_val = 0;
  printk(KERN_ALERT "FUNCTION AUTO GENERATED AT: 2020-10-14 16:44\n");
  pr_info("Initializing the Flat Earth simple_gain module\n");
  // Register our driver with the "Platform Driver" bus
  ret_val = platform_driver_register(&simple_gain_platform);  if (ret_val != 0) {
    pr_err("platform_driver_register returned %d\n", ret_val);
    return ret_val;
  }
  pr_info("Flat Earth simple_gain module successfully initialized!\n");
  return 0;
}
static int simple_gain_probe(struct platform_device *pdev) {
  int ret_val = -EBUSY;
  char device_name[23] = "fe_simple_gain_";
  char deviceMinor[20];
  int status;
  struct device *device_obj;
  fe_simple_gain_dev_t * fe_simple_gain_devp;
  struct resource *r = NULL;
  pr_info("simple_gain_probe enter\n");
  fe_simple_gain_devp = devm_kzalloc(&pdev->dev, sizeof(fe_simple_gain_dev_t), GFP_KERNEL);
  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (r == NULL) {
    pr_err("IORESOURCE_MEM (register space) does not exist\n");
    goto bad_exit_return;  }
  fe_simple_gain_devp->regs = devm_ioremap_resource(&pdev->dev, r);
  if (IS_ERR(fe_simple_gain_devp->regs)) {
    ret_val = PTR_ERR(fe_simple_gain_devp->regs);
    goto bad_exit_return;
  }
  platform_set_drvdata(pdev, (void *)fe_simple_gain_devp);
  fe_simple_gain_devp->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);
  if (fe_simple_gain_devp->name == NULL)
    goto bad_mem_alloc;
  strcpy(fe_simple_gain_devp->name, (char *)pdev->name);
  pr_info("%s\n", (char *)pdev->name);
  status = alloc_chrdev_region(&dev_num, 0, 1, "fe_simple_gain_");
  if (status != 0)
    goto bad_alloc_chrdev_region;
  sprintf(deviceMinor, "%d", MAJOR(dev_num));
  strcat(device_name, deviceMinor);
  pr_info("%s\n", device_name);
  cl = class_create(THIS_MODULE, device_name);
  if (cl == NULL)
    goto bad_class_create;
  cdev_init(&fe_simple_gain_devp->cdev, &fe_simple_gain_fops);
  status = cdev_add(&fe_simple_gain_devp->cdev, dev_num, 1);
  if (status != 0)
    goto bad_cdev_add;
 device_obj = device_create_with_groups(cl, NULL, dev_num, NULL, simple_gain_groups, device_name);
  if (device_obj == NULL)
    goto bad_device_create;
  dev_set_drvdata(device_obj, fe_simple_gain_devp);
  pr_info("simple_gain exit\n");
  return 0;
bad_device_create:
bad_cdev_add:
  cdev_del(&fe_simple_gain_devp->cdev);
bad_class_create:
  class_destroy(cl);
bad_alloc_chrdev_region:
  unregister_chrdev_region(dev_num, 1);
bad_mem_alloc:
bad_exit_return:
  pr_info("simple_gain_probe bad exit\n");
  return ret_val;
}


static int simple_gain_open(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static int simple_gain_release(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t simple_gain_read(struct file *file, char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t simple_gain_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}
static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_simple_gain_dev_t * devp = (fe_simple_gain_dev_t *)dev_get_drvdata(dev);
  sprintf(buf, "%s\n", devp->name);
  return strlen(buf);
}

static ssize_t Gain_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_simple_gain_dev_t * devp = (fe_simple_gain_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->Gain, 16, false, 20);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t Gain_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_simple_gain_dev_t *devp = (fe_simple_gain_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 16, false);
  devp->Gain = tempValue;
  iowrite32(devp->Gain, (u32 *)devp->regs + 0);
  return count;
}

static ssize_t Enable_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_simple_gain_dev_t * devp = (fe_simple_gain_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->Enable, 0, false, 1);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t Enable_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_simple_gain_dev_t *devp = (fe_simple_gain_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 0, false);
  devp->Enable = tempValue;
  iowrite32(devp->Enable, (u32 *)devp->regs + 1);
  return count;
}

static int simple_gain_remove(struct platform_device *pdev) {
  fe_simple_gain_dev_t *dev = (fe_simple_gain_dev_t *)platform_get_drvdata(pdev);
  pr_info("simple_gain_remove enter\n");
  device_destroy(cl, dev_num);
  cdev_del(&dev->cdev);
  class_destroy(cl);
  unregister_chrdev_region(dev_num, 2);
  pr_info("simple_gain_remove exit\n");
  return 0;
}


static void simple_gain_exit(void) {
  pr_info("Flat Earth simple_gain module exit\n");
  platform_driver_unregister(&simple_gain_platform);
  pr_info("Flat Earth simple_gain module successfully unregistered\n");
}
