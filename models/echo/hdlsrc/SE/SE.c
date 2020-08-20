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
struct fe_SE_dev {
  struct cdev cdev;
  void __iomem *regs;
  char *name;
  unsigned int enable;
  unsigned int delay;
  unsigned int feedback;
  unsigned int wet_dry_mix;
};

static int SE_init(void);
static void SE_exit(void);
static int SE_probe(struct platform_device *pdev);
static int SE_remove(struct platform_device *pdev);
static ssize_t SE_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t SE_write(struct file *file, const char *buffer, size_t len, loff_t *offset);
static int SE_open(struct inode *inode, struct file *file);
static int SE_release(struct inode *inode, struct file *file);

static ssize_t name_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t enable_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t enable_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t delay_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t delay_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t feedback_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t feedback_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t wet_dry_mix_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t wet_dry_mix_read  (struct device *dev, struct device_attribute *attr, char *buf);
typedef struct fe_SE_dev fe_SE_dev_t;
/* ID Matching struct */
static struct of_device_id fe_SE_dt_ids[] = {
  {
    .compatible = "dev,al-SE"
  },
  { }
};

/* Platform driver struct */
static struct platform_driver SE_platform = {
  .probe = SE_probe,
  .remove = SE_remove,
  .driver = {
    .name = "Flat Earth SE Driver",
    .owner = THIS_MODULE,
    .of_match_table = fe_SE_dt_ids
  }
};

/* File ops struct */
static const struct file_operations fe_SE_fops = {
  .owner = THIS_MODULE,
  .read = SE_read,
  .write = SE_write,
  .open = SE_open,
  .release = SE_release,
};


MODULE_LICENSE("GPL");
MODULE_AUTHOR("Autogen <support@flatearthinc.com");
MODULE_DESCRIPTION("Loadable kernel module for the SE");
MODULE_VERSION("1.0");
MODULE_DEVICE_TABLE(of, fe_SE_dt_ids);
module_init(SE_init);
module_exit(SE_exit);

DEVICE_ATTR(name, 0444, name_read, NULL);
DEVICE_ATTR(enable, 0664, enable_read, enable_write);
DEVICE_ATTR(delay, 0664, delay_read, delay_write);
DEVICE_ATTR(feedback, 0664, feedback_read, feedback_write);
DEVICE_ATTR(wet_dry_mix, 0664, wet_dry_mix_read, wet_dry_mix_write);
static struct attribute *SE_attrs[] = {  &dev_attr_name.attr,  &dev_attr_enable.attr,  &dev_attr_delay.attr,  &dev_attr_feedback.attr,  &dev_attr_wet_dry_mix.attr,  NULL};

ATTRIBUTE_GROUPS(SE);

static int SE_init(void) {
  int ret_val = 0;
  printk(KERN_ALERT "FUNCTION AUTO GENERATED AT: 2020-08-13 21:14\n");
  pr_info("Initializing the Flat Earth SE module\n");
  // Register our driver with the "Platform Driver" bus
  ret_val = platform_driver_register(&SE_platform);  if (ret_val != 0) {
    pr_err("platform_driver_register returned %d\n", ret_val);
    return ret_val;
  }
  pr_info("Flat Earth SE module successfully initialized!\n");
  return 0;
}
static int SE_probe(struct platform_device *pdev) {
  int ret_val = -EBUSY;
  char device_name[14] = "fe_SE_";
  char deviceMinor[20];
  int status;
  struct device *device_obj;
  fe_SE_dev_t * fe_SE_devp;
  struct resource *r = NULL;
  pr_info("SE_probe enter\n");
  fe_SE_devp = devm_kzalloc(&pdev->dev, sizeof(fe_SE_dev_t), GFP_KERNEL);
  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (r == NULL) {
    pr_err("IORESOURCE_MEM (register space) does not exist\n");
    goto bad_exit_return;  }
  fe_SE_devp->regs = devm_ioremap_resource(&pdev->dev, r);
  if (IS_ERR(fe_SE_devp->regs)) {
    ret_val = PTR_ERR(fe_SE_devp->regs);
    goto bad_exit_return;
  }
  platform_set_drvdata(pdev, (void *)fe_SE_devp);
  fe_SE_devp->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);
  if (fe_SE_devp->name == NULL)
    goto bad_mem_alloc;
  strcpy(fe_SE_devp->name, (char *)pdev->name);
  pr_info("%s\n", (char *)pdev->name);
  status = alloc_chrdev_region(&dev_num, 0, 1, "fe_SE_");
  if (status != 0)
    goto bad_alloc_chrdev_region;
  sprintf(deviceMinor, "%d", MAJOR(dev_num));
  strcat(device_name, deviceMinor);
  pr_info("%s\n", device_name);
  cl = class_create(THIS_MODULE, device_name);
  if (cl == NULL)
    goto bad_class_create;
  cdev_init(&fe_SE_devp->cdev, &fe_SE_fops);
  status = cdev_add(&fe_SE_devp->cdev, dev_num, 1);
  if (status != 0)
    goto bad_cdev_add;
 device_obj = device_create_with_groups(cl, NULL, dev_num, NULL, SE_groups, device_name);
  if (device_obj == NULL)
    goto bad_device_create;
  dev_set_drvdata(device_obj, fe_SE_devp);
  pr_info("SE exit\n");
  return 0;
bad_device_create:
bad_cdev_add:
  cdev_del(&fe_SE_devp->cdev);
bad_class_create:
  class_destroy(cl);
bad_alloc_chrdev_region:
  unregister_chrdev_region(dev_num, 1);
bad_mem_alloc:
bad_exit_return:
  pr_info("SE_probe bad exit\n");
  return ret_val;
}


static int SE_open(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static int SE_release(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t SE_read(struct file *file, char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t SE_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}
static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_SE_dev_t * devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  sprintf(buf, "%s\n", devp->name);
  return strlen(buf);
}

static ssize_t enable_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_SE_dev_t * devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->enable, 0, false, 1);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t enable_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_SE_dev_t *devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 0, false);
  devp->enable = tempValue;
  iowrite32(devp->enable, (u32 *)devp->regs + 0);
  return count;
}

static ssize_t delay_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_SE_dev_t * devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->delay, 0, false, 15);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t delay_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_SE_dev_t *devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 0, false);
  devp->delay = tempValue;
  iowrite32(devp->delay, (u32 *)devp->regs + 1);
  return count;
}

static ssize_t feedback_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_SE_dev_t * devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->feedback, 7, false, 8);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t feedback_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_SE_dev_t *devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 7, false);
  devp->feedback = tempValue;
  iowrite32(devp->feedback, (u32 *)devp->regs + 2);
  return count;
}

static ssize_t wet_dry_mix_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_SE_dev_t * devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->wet_dry_mix, 7, false, 8);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t wet_dry_mix_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_SE_dev_t *devp = (fe_SE_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 7, false);
  devp->wet_dry_mix = tempValue;
  iowrite32(devp->wet_dry_mix, (u32 *)devp->regs + 3);
  return count;
}

static int SE_remove(struct platform_device *pdev) {
  fe_SE_dev_t *dev = (fe_SE_dev_t *)platform_get_drvdata(pdev);
  pr_info("SE_remove enter\n");
  device_destroy(cl, dev_num);
  cdev_del(&dev->cdev);
  class_destroy(cl);
  unregister_chrdev_region(dev_num, 2);
  pr_info("SE_remove exit\n");
  return 0;
}


static void SE_exit(void) {
  pr_info("Flat Earth SE module exit\n");
  platform_driver_unregister(&SE_platform);
  pr_info("Flat Earth SE module successfully unregistered\n");
}
