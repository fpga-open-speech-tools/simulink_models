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

#define n_nums 1024
#define max_char 20


static struct class *cl;
static dev_t dev_num;
/* Device struct */
struct fe_dpr_test_dev {
  struct cdev cdev;
  void __iomem *regs;
  char *name;
  unsigned int dpr_data;
};

static int dpr_test_init(void);
static void dpr_test_exit(void);
static int dpr_test_probe(struct platform_device *pdev);
static int dpr_test_remove(struct platform_device *pdev);
static ssize_t dpr_test_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t dpr_test_write(struct file *file, const char *buffer, size_t len, loff_t *offset);
static int dpr_test_open(struct inode *inode, struct file *file);
static int dpr_test_release(struct inode *inode, struct file *file);

static ssize_t name_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t dpr_data_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t dpr_data_read  (struct device *dev, struct device_attribute *attr, char *buf);
typedef struct fe_dpr_test_dev fe_dpr_test_dev_t;
/* ID Matching struct */
static struct of_device_id fe_dpr_test_dt_ids[] = {
  {
    .compatible = "dev,al-dpr_test"
  },
  { }
};

/* Platform driver struct */
static struct platform_driver dpr_test_platform = {
  .probe = dpr_test_probe,
  .remove = dpr_test_remove,
  .driver = {
    .name = "Flat Earth dpr_test Driver",
    .owner = THIS_MODULE,
    .of_match_table = fe_dpr_test_dt_ids
  }
};

/* File ops struct */
static const struct file_operations fe_dpr_test_fops = {
  .owner = THIS_MODULE,
  .read = dpr_test_read,
  .write = dpr_test_write,
  .open = dpr_test_open,
  .release = dpr_test_release,
};


MODULE_LICENSE("GPL");
MODULE_AUTHOR("Autogen <support@flatearthinc.com");
MODULE_DESCRIPTION("Loadable kernel module for the dpr_test");
MODULE_VERSION("1.0");
MODULE_DEVICE_TABLE(of, fe_dpr_test_dt_ids);
module_init(dpr_test_init);
module_exit(dpr_test_exit);

DEVICE_ATTR(name, 0444, name_read, NULL);
DEVICE_ATTR(dpr_data, 0664, dpr_data_read, dpr_data_write);
static struct attribute *dpr_test_attrs[] = {  &dev_attr_name.attr,  &dev_attr_dpr_data.attr,  NULL};

ATTRIBUTE_GROUPS(dpr_test);

static int dpr_test_init(void) {
  int ret_val = 0;
  printk(KERN_ALERT "FUNCTION AUTO GENERATED AT: 2020-10-20 11:10\n");
  pr_info("Initializing the Flat Earth dpr_test module\n");
  // Register our driver with the "Platform Driver" bus
  ret_val = platform_driver_register(&dpr_test_platform);  if (ret_val != 0) {
    pr_err("platform_driver_register returned %d\n", ret_val);
    return ret_val;
  }
  pr_info("Flat Earth dpr_test module successfully initialized!\n");
  return 0;
}
static int dpr_test_probe(struct platform_device *pdev) {
  int ret_val = -EBUSY;
  char device_name[20] = "fe_dpr_test_";
  char deviceMinor[20];
  int status;
  struct device *device_obj;
  fe_dpr_test_dev_t * fe_dpr_test_devp;
  struct resource *r = NULL;
  pr_info("dpr_test_probe enter\n");
  fe_dpr_test_devp = devm_kzalloc(&pdev->dev, sizeof(fe_dpr_test_dev_t), GFP_KERNEL);
  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (r == NULL) {
    pr_err("IORESOURCE_MEM (register space) does not exist\n");
    goto bad_exit_return;  }
  fe_dpr_test_devp->regs = devm_ioremap_resource(&pdev->dev, r);
  if (IS_ERR(fe_dpr_test_devp->regs)) {
    ret_val = PTR_ERR(fe_dpr_test_devp->regs);
    goto bad_exit_return;
  }
  platform_set_drvdata(pdev, (void *)fe_dpr_test_devp);
  fe_dpr_test_devp->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);
  if (fe_dpr_test_devp->name == NULL)
    goto bad_mem_alloc;
  strcpy(fe_dpr_test_devp->name, (char *)pdev->name);
  pr_info("%s\n", (char *)pdev->name);
  status = alloc_chrdev_region(&dev_num, 0, 1, "fe_dpr_test_");
  if (status != 0)
    goto bad_alloc_chrdev_region;
  sprintf(deviceMinor, "%d", MAJOR(dev_num));
  strcat(device_name, deviceMinor);
  pr_info("%s\n", device_name);
  cl = class_create(THIS_MODULE, device_name);
  if (cl == NULL)
    goto bad_class_create;
  cdev_init(&fe_dpr_test_devp->cdev, &fe_dpr_test_fops);
  status = cdev_add(&fe_dpr_test_devp->cdev, dev_num, 1);
  if (status != 0)
    goto bad_cdev_add;
 device_obj = device_create_with_groups(cl, NULL, dev_num, NULL, dpr_test_groups, device_name);
  if (device_obj == NULL)
    goto bad_device_create;
  dev_set_drvdata(device_obj, fe_dpr_test_devp);
  pr_info("dpr_test exit\n");
  return 0;
bad_device_create:
bad_cdev_add:
  cdev_del(&fe_dpr_test_devp->cdev);
bad_class_create:
  class_destroy(cl);
bad_alloc_chrdev_region:
  unregister_chrdev_region(dev_num, 1);
bad_mem_alloc:
bad_exit_return:
  pr_info("dpr_test_probe bad exit\n");
  return ret_val;
}


static int dpr_test_open(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static int dpr_test_release(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t dpr_test_read(struct file *file, char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t dpr_test_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}
static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_dpr_test_dev_t * devp = (fe_dpr_test_dev_t *)dev_get_drvdata(dev);
  sprintf(buf, "%s\n", devp->name);
  return strlen(buf);
}

static ssize_t dpr_data_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_dpr_test_dev_t * devp = (fe_dpr_test_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->dpr_data, 0, false, 32);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t dpr_data_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {

  int i,c;
	uint32_t num;
  char substring[max_char];
  int substring_count = 0;
  int num_counter = 0;
  
  fe_dpr_test_dev_t *devp = (fe_dpr_test_dev_t *)dev_get_drvdata(dev);

  // Check to see if the function was called with an empty string
  if (count < 2)
    return count;
    
  for (i = 0; i < count; i++)
  {
    //If its not a space or a comma, add the digit to the substring
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n'))
    {
      substring[substring_count] = buf[i];
      substring_count++;
    }
    else 
    {
      substring[substring_count] = '\0';
      num = set_fixed_num(substring,8,false);
      iowrite32((num & 0x0000FFFF) + (((uint32_t)num_counter)<<16), (u32 *)devp->regs + 0);
      
      for (c = 0; c <= substring_count; c++)
        substring[c] = '\0';
      substring_count = 0;
      num_counter += 1;
      
    }
  } 
	return count;
}

static int dpr_test_remove(struct platform_device *pdev) {
  fe_dpr_test_dev_t *dev = (fe_dpr_test_dev_t *)platform_get_drvdata(pdev);
  pr_info("dpr_test_remove enter\n");
  device_destroy(cl, dev_num);
  cdev_del(&dev->cdev);
  class_destroy(cl);
  unregister_chrdev_region(dev_num, 2);
  pr_info("dpr_test_remove exit\n");
  return 0;
}


static void dpr_test_exit(void) {
  pr_info("Flat Earth dpr_test module exit\n");
  platform_driver_unregister(&dpr_test_platform);
  pr_info("Flat Earth dpr_test module successfully unregistered\n");
}
