(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	spectrograph0 - mode
	thermograph1 - mode
	image2 - mode
	Star2 - direction
	Star5 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation9 - direction
	GroundStation7 - direction
	Star11 - direction
	Star6 - direction
	GroundStation4 - direction
	Star1 - direction
	Star0 - direction
	GroundStation3 - direction
	Planet12 - direction
	Planet13 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Planet17 - direction
	Planet18 - direction
	Phenomenon19 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star0)
	(supports instrument1 spectrograph0)
	(supports instrument1 thermograph1)
	(supports instrument1 image2)
	(calibration_target instrument1 GroundStation7)
	(supports instrument2 thermograph1)
	(supports instrument2 image2)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star0)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon15)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 Star0)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation3)
	(supports instrument4 thermograph1)
	(supports instrument4 spectrograph0)
	(supports instrument4 image2)
	(calibration_target instrument4 GroundStation3)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation3)
)
(:goal (and
	(pointing satellite0 Star2)
	(pointing satellite1 GroundStation9)
	(have_image Planet12 thermograph1)
	(have_image Planet13 thermograph1)
	(have_image Planet14 image2)
	(have_image Phenomenon15 thermograph1)
	(have_image Star16 spectrograph0)
	(have_image Planet17 thermograph1)
	(have_image Planet18 image2)
	(have_image Phenomenon19 thermograph1)
))

)
