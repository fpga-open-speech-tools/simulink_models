/*********************************************************************
Generated in CreateFileHeaderInfo 
*********************************************************************/
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

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Tyler Davis <support@flatearthinc.com");
MODULE_DESCRIPTION("Loadable kernel module for the bitcrusher");
MODULE_VERSION("1.0");
/* End CreateFileHeaderInfo */


/***********************************************
  Generated in CreateMiscTopOfFile
***********************************************/
struct fixed_num {
  int integer;
  int fraction;
  int fraction_len;
};
static struct class *cl;  // Global variable for the device class
static dev_t dev_num;

/*********** Device type specific things **************/
//TODO: check this. Register memory map. Was not pulled from input params, might want to verify this
#define BAND_ALL_OFFSET 0x00
#define BAND1_OFFSET 0x01
#define BAND2_OFFSET 0x02
#define BAND3_OFFSET 0x03
#define BAND4_OFFSET 0x04
#define LEFT_OFFSET 0x00
#define RIGHT_OFFSET 0x08
#define GAIN_OFFSET 0
/* End of CreateMiscTopOfFile */


/*****************************************************
Generate in CreateFunctionPrototypes
*****************************************************/
static int bitcrusher_probe(struct platform_device *pdev);
static int bitcrusher_remove(struct platform_device *pdev);
static ssize_t bitcrusher_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t bitcrusher_write(struct file *file, const char *buffer, size_t len, loff_t *offset);
static int bitcrusher_open(struct inode *inode, struct file *file);
static int bitcrusher_release(struct inode *inode, struct file *file);
static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf);

/************** Generate device specific prototypes ********************/
// FPGA device funcs
static ssize_t bypass_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t bypass_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t bits_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t bits_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t wet_dry_mix_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t wet_dry_mix_read  (struct device *dev, struct device_attribute *attr, char *buf);

/* Custom function declarations */
/* End CreateFunctionPrototypes */


/*************************************************
Generated in WriteDeviceAttributes
*************************************************/
DEVICE_ATTR(bypass, 0664, bypass_read, bypass_write);
DEVICE_ATTR(bits, 0664, bits_read, bits_write);
DEVICE_ATTR(wet_dry_mix, 0664, wet_dry_mix_read, wet_dry_mix_write);
DEVICE_ATTR(name, 0444, name_read, NULL);
/* End WriteDeviceAttributes */


/****************************************************
Generated in CreateDriverStuff
****************************************************/

/* Device struct */
struct fe_bitcrusher_dev {
  struct cdev cdev;
  char *name;
  void __iomem *regs;
  int bypass;
  int bits;
  int wet_dry_mix;
};

typedef struct fe_bitcrusher_dev fe_bitcrusher_dev_t;
/* ID Matching struct */
static struct of_device_id fe_bitcrusher_dt_ids[] = {
  {
    .compatible = "dev,fe-bitcrusher"
  },
  { }
};

MODULE_DEVICE_TABLE(of, fe_bitcrusher_dt_ids);
/* Platform driver struct */
static struct platform_driver bitcrusher_platform = {
  .probe = bitcrusher_probe,
  .remove = bitcrusher_remove,
  .driver = {
    .name = "Flat Earth bitcrusher Driver",
    .owner = THIS_MODULE,
    .of_match_table = fe_bitcrusher_dt_ids
  }
};

/* File ops struct */
static const struct file_operations fe_bitcrusher_fops = {
  .owner = THIS_MODULE,
  .read = bitcrusher_read,
  .write = bitcrusher_write,
  .open = bitcrusher_open,
  .release = bitcrusher_release,
};

/* End of CreateDriverStuff */


/*********************************************************
Generated in CreateInitFunction
*********************************************************/
static int bitcrusher_init(void) {
  printk(KERN_ALERT "FUNCTION AUTO GENERATED AT: 2019-10-06 20:30\n");
  int ret_val = 0;
  pr_info("Initializing the Flat Earth bitcrusher module\n");
  // Register our driver with the "Platform Driver" bus
  ret_val = platform_driver_register(&bitcrusher_platform);  if (ret_val != 0) {
    pr_err("platform_driver_register returned %d\n", ret_val);
    return ret_val;
  }
  pr_info("Flat Earth bitcrusher module successfully initialized!\n");
  return 0;
}
/* End CreateInitFunction */

/************************************************
Generated by CreateProbeFunction
************************************************/
static int bitcrusher_probe(struct platform_device *pdev) {
  int ret_val = -EBUSY;
  char deviceName[22] = "fe_bitcrusher_";
  char deviceMinor[20];
  int status;
  struct device *device_obj;
  fe_bitcrusher_dev_t * fe_bitcrusher_devp;
  pr_info("bitcrusher_probe enter\n");
  struct resource *r = 0;
  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (r == NULL) {
    pr_err("IORESOURCE_MEM (register space) does not exist\n");
    goto bad_exit_return;  }
  fe_bitcrusher_devp = devm_kzalloc(&pdev->dev, sizeof(fe_bitcrusher_dev_t), GFP_KERNEL);
  fe_bitcrusher_devp->regs = devm_ioremap_resource(&pdev->dev, r);
  if (IS_ERR(fe_bitcrusher_devp->regs))
    goto bad_ioremap;
  platform_set_drvdata(pdev, (void *)fe_bitcrusher_devp);
  fe_bitcrusher_devp->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);
  if (fe_bitcrusher_devp->name == NULL)
    goto bad_mem_alloc;
  strcpy(fe_bitcrusher_devp->name, (char *)pdev->name);
  pr_info("%s\n", (char *)pdev->name);
  status = alloc_chrdev_region(&dev_num, 0, 1, "fe_bitcrusher_");
  if (status != 0)
    goto bad_alloc_chrdev_region;
  sprintf(deviceMinor, "%d", MAJOR(dev_num));
  strcat(deviceName, deviceMinor);
  pr_info("%s\n", deviceName);
  cl = class_create(THIS_MODULE, deviceName);
  if (cl == NULL)
    goto bad_class_create;
  cdev_init(&fe_bitcrusher_devp->cdev, &fe_bitcrusher_fops);
  status = cdev_add(&fe_bitcrusher_devp->cdev, dev_num, 1);
  if (status != 0)
    goto bad_cdev_add;
  device_obj = device_create(cl, NULL, dev_num, NULL, deviceName);
  if (device_obj == NULL)
    goto bad_device_create;
  dev_set_drvdata(device_obj, fe_bitcrusher_devp);
/* Beginning attribute file stuff */
  status = device_create_file(device_obj, &dev_attr_bypass);
  if (status)
    goto bad_device_create_file_1;

  status = device_create_file(device_obj, &dev_attr_bits);
  if (status)
    goto bad_device_create_file_2;

  status = device_create_file(device_obj, &dev_attr_wet_dry_mix);
  if (status)
    goto bad_device_create_file_3;

  status = device_create_file(device_obj, &dev_attr_name);
  if (status)
    goto bad_device_create_file_4;
  pr_info("HA_probe exit\n");
  return 0;
bad_device_create_file_4:
  device_remove_file(device_obj, &dev_attr_name);
bad_device_create_file_3:
  device_remove_file(device_obj, &dev_attr_wet_dry_mix);

bad_device_create_file_2:
  device_remove_file(device_obj, &dev_attr_bits);

bad_device_create_file_1:
  device_remove_file(device_obj, &dev_attr_bypass);

bad_device_create_file_0:
  device_destroy(cl, dev_num);

bad_device_create:
  cdev_del(&fe_bitcrusher_devp->cdev);
bad_cdev_add:
  class_destroy(cl);
bad_class_create:
  unregister_chrdev_region(dev_num, 1);
bad_alloc_chrdev_region:
bad_mem_alloc:
bad_ioremap:
  ret_val = PTR_ERR(fe_bitcrusher_devp->regs);
bad_exit_return:
  pr_info("bitcrusher_probe bad exit\n");
  return ret_val;
}
/* End of CreateProbeFunction */


/*****************************************************
Generated by CreateAttrReadWriteFuncs
****************************************************/
// FPGA Attribute functions
static ssize_t bypass_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_bitcrusher_dev_t * devp = (fe_bitcrusher_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->bypass, an, true, 9);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t bypass_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_bitcrusher_dev_t *devp = (fe_bitcrusher_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, an, false);
  devp->bypass = tempValue;
  iowrite32(devp->bypass, (u32 *)devp->regs + 0);
  return count;
}

static ssize_t bits_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_bitcrusher_dev_t * devp = (fe_bitcrusher_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->bits, x5, true, 9);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t bits_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_bitcrusher_dev_t *devp = (fe_bitcrusher_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, x5, false);
  devp->bits = tempValue;
  iowrite32(devp->bits, (u32 *)devp->regs + 1);
  return count;
}

static ssize_t wet_dry_mix_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_bitcrusher_dev_t * devp = (fe_bitcrusher_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->wet_dry_mix, n4, true, 9);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t wet_dry_mix_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_bitcrusher_dev_t *devp = (fe_bitcrusher_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, n4, false);
  devp->wet_dry_mix = tempValue;
  iowrite32(devp->wet_dry_mix, (u32 *)devp->regs + 2);
  return count;
}

static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_bitcrusher_dev_t *devp = (fe_bitcrusher_dev_t *)dev_get_drvdata(dev);
  sprintf(buf, "%s\n", devp->name);
  return strlen(buf);
}
/* End of CreateAttrReadWriteFuncs */


/*****************************************
  Generated by CreateCFunctionStubs
*****************************************/
static int bitcrusher_open(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static int bitcrusher_release(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t bitcrusher_read(struct file *file, char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t bitcrusher_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}
 /* End CreateCFunctionStubs */


/******************************************************
Generated in CreateRemoveFunction
*******************************************************/
static int bitcrusher_remove(struct platform_device *pdev) {
  fe_bitcrusher_dev_t *dev = (fe_bitcrusher_dev_t *)platform_get_drvdata(pdev);
  pr_info("bitcrusher_remove enter\n");
  cdev_del(&dev->cdev);
  unregister_chrdev_region(dev_num, 2);
  iounmap(dev->regs);
  pr_info("bitcrusher_remove exit\n");
  return 0;
}
/* End CreateRemoveFunction */


/***********************************************
Generated by CreateExitFunction
************************************************/
static void bitcrusher_exit(void) {
  pr_info("Flat Earth bitcrusher module exit\n");
  platform_driver_unregister(&bitcrusher_platform);
  pr_info("Flat Earth bitcrusher module successfully unregistered\n");
}
/* End CreateExitFunction */


/*********************************************
Generated by CreateCustomFunctions
**********************************************/
/* End CreateCustomFunctions */


/********************************************
Generated by CreateEndOfFileStuff
********************************************/
module_init(bitcrusher_init);
module_exit(bitcrusher_exit);
/* End CreateEndOfFileStuff */
